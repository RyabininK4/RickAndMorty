//
//  ListOfHeroesViewModel.swift
//  RickAndMorty
//
//  Created by Kirill Riabinin on 26.10.2022.
//

import Foundation

enum ViewModelState: Equatable {
    case loading
    case finished
    case error(NetworkError)
}

final class ListOfHeroesViewModel {
    
    // MARK: - Private properties
    
    private var maxPages = 1
    private var currentPage = 1
    private var networkService: NetworkServiceType
    
    // MARK: - Properties
    
    let titlePage = "List of heroes"
    
    @Published private(set) var heroes: [Hero] = []
    @Published private(set) var state: ViewModelState = .loading
    
    // MARK: - Init
    
    init(networkService: NetworkServiceType) {
        self.networkService = networkService
    }
    
    // MARK: - Download data methods
    
    func fetchData() {
        currentPage = 1
        fetch(by: currentPage)
    }
    
    func loadMoreItemsForList() {
        if state != .loading, maxPages > currentPage {
            currentPage += 1
            fetch(by: currentPage)
        }
    }
    
    // MARK: - Network
    
    private func fetch(by page: Int) {
        guard let url = API.makeUrl(with: .pageHeroes(page: page)) else {
            return
        }
        print("KR+ \(page)")
        state = .loading
        networkService.request(url: url) { [weak self] (result: Result<HeroesResponse, NetworkError>) in
            guard let self = self else {
                return
            }
            switch result {
            case .failure(let error):
                self.state = .error(error)
            case .success(let data):
                if page == 1 {
                    self.heroes = data.results
                } else {
                    self.heroes.append(contentsOf: data.results)
                }
                self.maxPages = data.info.pages
                self.state = .finished
            }
        }
    }
}
