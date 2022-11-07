//
//  APIService.swift
//  RickAndMorty
//
//  Created by Kirill Riabinin on 02.11.2022.
//

import Foundation
import Combine

final class APIService {
    
    // MARK: - Private properties
    
    private var networkService: NetworkServiceType
    
    // MARK: - Init
    
    init(networkService: NetworkServiceType) {
        self.networkService = networkService
    }
    
    // MARK: - API
    
    func fetchHeroesList() -> AnyPublisher<HeroesResponse, NetworkError> {
        return fetchNetworkRequest(by: API.makeUrl(with: .firstPageHeroes))
    }
    
    func heroes(by page: Int) -> AnyPublisher<HeroesResponse, NetworkError> {
        return fetchNetworkRequest(by: API.makeUrl(with: .heroes(page: page)))
    }

    func hero(by id: Int) -> AnyPublisher<Hero, NetworkError> {
        return fetchNetworkRequest(by: API.makeUrl(with: .heroDetails(id: id)))
    }
    
    func location(by location: Location) -> AnyPublisher<Location, NetworkError> {
        return fetchNetworkRequest(by: URL(string: location.url))
    }
    
    func episode(by url: String) -> AnyPublisher<Episode, NetworkError> {
        return fetchNetworkRequest(by: URL(string: url))
    }
    
    // MARK: - NetworkService
    
    private func fetchNetworkRequest<T: Codable>(by url: URL?) -> AnyPublisher<T, NetworkError> {
        let pass = PassthroughSubject<T, NetworkError>()
        guard let url = url else {
            pass.send(completion: .failure(.urlError))
            return pass.eraseToAnyPublisher()
        }
        networkService.request(url: url) { (result: Result<T, NetworkError>) in
            switch result {
            case .failure(let error):
                pass.send(completion: .failure(error))
            case .success(let data):
                pass.send(data)
                pass.send(completion: .finished)
            }
        }
        return pass.eraseToAnyPublisher()
    }
}
