//
//  HeroDetailViewModel.swift
//  RickAndMorty
//
//  Created by Kirill Riabinin on 26.10.2022.
//

import Foundation

final class HeroDetailViewModel {
    
    // MARK: - Properties
    
    var hero: Hero?
    var location: Location?
    var episodes: [EpisodeViewModel] = []
    @Published var isLoading = false
    @Published var error: NetworkError?
    
    // MARK: - Private properties
    
    private let group = DispatchGroup()
    private let queue = DispatchQueue.global(qos: .background)
    private var networkService: NetworkServiceType
    
    // MARK: - Init
    
    init(hero: Hero, networkService: NetworkServiceType) {
        self.hero = hero
        self.networkService = networkService
    }
    
    // MARK: - Networking
    
    func fetchData(id: Int) {
        self.isLoading = true
        hero(by: id) { [weak self] in
            guard let self = self else {
                return
            }
            
            self.queue.async {
                if let location = self.hero?.location {
                    self.location(by: location)
                }
                
                self.hero?.episode?.forEach({ self.episode(by: $0) })
                
                self.group.notify(queue: DispatchQueue.main) {
                    self.isLoading = false
                }
            }
        }
    }
    
    private func hero(by id: Int, _ completion: (() -> Void)? = nil) {
        guard let url = API.makeUrl(with: .heroDetails(id: id)) else {
            return
        }
        networkService.request(url: url) { [weak self] (result: Result<Hero, NetworkError>) in
            guard let self = self else {
                return
            }
            switch result {
            case .failure(let error):
                self.error = error
            case .success(let hero):
                self.hero = hero
            }
            completion?()
        }
    }
    
    private func location(by location: Location) {
        guard let stringUrl = location.url, let url = URL(string: stringUrl) else {
            return
        }
        group.enter()
        networkService.request(url: url) { [weak self] (result: Result<Location, NetworkError>) in
            guard let self = self else {
                return
            }
            switch result {
            case .failure(let error):
                self.error = error
            case .success(let location):
                self.location = location
            }
            self.group.leave()
        }
    }
    
    private func episode(by url: String) {
        guard let url = URL(string: url) else {
            return
        }
        group.enter()
        networkService.request(url: url) { [weak self] (result: Result<Episode, NetworkError>) in
            guard let self = self else {
                return
            }
            switch result {
            case .failure(let error):
                self.error = error
            case .success(let episode):
                self.episodes.append(EpisodeViewModel(for: episode))
            }
            self.group.leave()
        }
    }
}
