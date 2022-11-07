//
//  ListOfHeroesViewModel.swift
//  RickAndMorty
//
//  Created by Kirill Riabinin on 26.10.2022.
//

import Foundation
import Combine

final class ListOfHeroesViewModel {
    
    // MARK: - Private properties
    
    private let maxPagesDownload = 3
    private var maxPage = 1
    private var lastDownloadPage = 1
    private var apiService: APIService
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Properties
    
    let titlePage = "List of heroes"
    
    @Published private(set) var heroes: [Hero] = []
    @Published private(set) var state: ViewModelState = .loading
    
    // MARK: - Init
    
    init(networkService: NetworkServiceType) {
        self.apiService = APIService(networkService: networkService)
    }
    
    // MARK: - Download data methods
    
    func fetchData() {
        state = .loading
        apiService.fetchHeroesList()
            .receive(on: RunLoop.main)
            .sink { [weak self] result in
                guard let self = self else {
                    return
                }
                switch result {
                case .failure(let error):
                    self.state = .error(error)
                case .finished:
                    self.state = .finished
                    self.loadMoreItemsForList()
                }
            } receiveValue: { [weak self] value in
                guard let self = self else {
                    return
                }
                self.heroes = value.results
                self.maxPage = value.info.pages
            }.store(in: &subscriptions)
    }
    
    private func loadMoreItemsForList() {
        var publishers: [AnyPublisher<HeroesResponse, NetworkError>] = []
        
        for _ in 0..<maxPagesDownload {
            lastDownloadPage += 1
            if lastDownloadPage < maxPage {
                publishers.append(apiService.heroes(by: lastDownloadPage))
            } else {
                break
            }
        }
        
        publishers.publisher
            .receive(on: RunLoop.main)
            .flatMap({ $0 })
            .collect()
            .sink { [weak self] result in
                guard let self = self else {
                    return
                }
                switch result {
                case .failure(let error):
                    print(error)
                case .finished:
                    if self.lastDownloadPage < self.maxPage {
                        self.loadMoreItemsForList()
                    }
                }
            } receiveValue: { [weak self] value in
                guard let self = self else {
                    return
                }
                self.heroes.append(contentsOf: value.map({ $0.results }).reduce([], +))
            }.store(in: &subscriptions)
    }
}
