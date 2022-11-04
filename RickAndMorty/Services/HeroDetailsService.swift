//
//  HeroDetailsService.swift
//  RickAndMorty
//
//  Created by Kirill Riabinin on 02.11.2022.
//

import Foundation
import Combine

final class HeroDetailsService {
    
    // MARK: - Private properties
    
    private var networkService: NetworkServiceType
    
    // MARK: - Init
    
    init(networkService: NetworkServiceType) {
        self.networkService = networkService
    }

    func hero(by id: Int) -> AnyPublisher<Hero, NetworkError> {
        let pass = PassthroughSubject<Hero, NetworkError>()
        guard let url = API.makeUrl(with: .heroDetails(id: id)) else {
            pass.send(completion: .failure(.urlError))
            return pass.eraseToAnyPublisher()
        }
        networkService.request(url: url) { (result: Result<Hero, NetworkError>) in
            switch result {
            case .failure(let error):
                pass.send(completion: .failure(error))
            case .success(let hero):
                pass.send(hero)
                pass.send(completion: .finished)
            }
        }
        return pass.eraseToAnyPublisher()
    }
    
    func location(by location: Location) -> AnyPublisher<Location, NetworkError> {
        let pass = PassthroughSubject<Location, NetworkError>()
        guard let url = URL(string: location.url) else {
            pass.send(completion: .failure(.urlError))
            return pass.eraseToAnyPublisher()
        }
        networkService.request(url: url) { (result: Result<Location, NetworkError>) in
            switch result {
            case .failure(let error):
                pass.send(completion: .failure(error))
            case .success(let location):
                pass.send(location)
                pass.send(completion: .finished)
            }
        }
        return pass.eraseToAnyPublisher()
    }
    
    func episode(by url: String) -> AnyPublisher<Episode, NetworkError> {
        let pass = PassthroughSubject<Episode, NetworkError>()
        guard let url = URL(string: url) else {
            pass.send(completion: .failure(.urlError))
            return pass.eraseToAnyPublisher()
        }
        networkService.request(url: url) { (result: Result<Episode, NetworkError>) in
            switch result {
            case .failure(let error):
                pass.send(completion: .failure(error))
            case .success(let episode):
                pass.send(episode)
                pass.send(completion: .finished)
            }
        }
        return pass.eraseToAnyPublisher()
    }
}
