//
//  HeroDetailViewModel.swift
//  RickAndMorty
//
//  Created by Kirill Riabinin on 26.10.2022.
//

import Foundation
import Combine

final class HeroDetailViewModel {
    
    // MARK: - Properties
    
    var hero: Hero
    var location: Location?
    var episodes: [EpisodeViewModel] = []
    
    @Published private(set) var state: ViewModelState = .loading
    
    // MARK: - Private properties
    
    private var detailsService: HeroDetailsService
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Init
    
    init(hero: Hero, networkService: NetworkServiceType) {
        self.hero = hero
        self.detailsService = HeroDetailsService(networkService: networkService)
    }
    
    // MARK: - Networking
    
    func fetchData() {
        state = .loading
        
        detailsService.hero(by: hero.id)
            .receive(on: RunLoop.main)
            .sink { [weak self] result in
                guard let self = self else {
                    return
                }
                switch result {
                case .failure(let error):
                    self.state = .error(error)
                case .finished:
                    self.fetchAdditionalData()
                }
            } receiveValue: { [weak self] value in
                guard let self = self else {
                    return
                }
                self.hero = value
            }.store(in: &subscriptions)
    }
    
    private func fetchAdditionalData() {
        hero.episode.map({ detailsService.episode(by: $0) })
            .publisher
            .receive(on: RunLoop.main)
            .flatMap({ $0 })
            .collect()
            .combineLatest(detailsService.location(by: hero.location))
            .sink { [weak self] result in
                guard let self = self else {
                    return
                }
                switch result {
                case .failure(let error):
                    self.state = .error(error)
                case .finished:
                    self.state = .finished
                }
            } receiveValue: { [weak self] (episodes, location) in
                guard let self = self else {
                    return
                }
                self.episodes = episodes.map({ EpisodeViewModel(for: $0) })
                self.location = location
            }.store(in: &subscriptions)
    }
}
