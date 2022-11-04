//
//  ListOfHeroesViewModel.swift
//  RickAndMorty
//
//  Created by Kirill Riabinin on 26.10.2022.
//

import Foundation

final class ListOfHeroesViewModel {
    
    // MARK: - Private properties
    private let maxPagesDownload = 3
    private var maxPage = 1
    private var lastDownloadPage = 1
    private var networkService: NetworkServiceType
    private var group = DispatchGroup()
    
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
        fetchFirstPage()
    }
    
    private func loadMoreItemsForList() {
        group = DispatchGroup()
        
        for _ in 0..<maxPagesDownload {
            lastDownloadPage += 1
            if lastDownloadPage < maxPage {
                fetch(by: lastDownloadPage)
            } else {
                break
            }
        }
        
        group.notify(queue: DispatchQueue.main) { [weak self] in
            guard let self = self else {
                return
            }
            if self.lastDownloadPage < self.maxPage {
                self.loadMoreItemsForList()
            }
        }
    }
    
    // MARK: - Network
    
    private func fetchFirstPage() {
        guard let url = API.makeUrl(with: .firstPageHeroes) else {
            return
        }
        state = .loading
        networkService.request(url: url) { [weak self] (result: Result<HeroesResponse, NetworkError>) in
            guard let self = self else {
                return
            }
            switch result {
            case .failure(let error):
                self.state = .error(error)
            case .success(let data):
                self.heroes = data.results
                self.maxPage = data.info.pages
                self.state = .finished
                self.loadMoreItemsForList()
            }
        }
    }
    
    private func fetch(by page: Int) {
        guard let url = API.makeUrl(with: .heroes(page: page)) else {
            return
        }
        group.enter()
        networkService.request(url: url) { [weak self] (result: Result<HeroesResponse, NetworkError>) in
            guard let self = self else {
                return
            }
            switch result {
            case .failure(_):
                break
            case .success(let data):
                self.heroes.append(contentsOf: data.results)
            }
            self.group.leave()
        }
    }
}
