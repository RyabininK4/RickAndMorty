//
//  NetworkService.swift
//  RickAndMorty
//
//  Created by Kirill Riabinin on 26.10.2022.
//

import Foundation

protocol NetworkServiceType {
    func request<T: Codable>(url: URL, _ completion: @escaping ((Result<T, NetworkError>) -> Void))
    func download(url: URL, _ completion: @escaping ((Result<Data, NetworkError>) -> Void))
}

final class NetworkService: NetworkServiceType {

    // MARK: - Constants
    
    private let session: URLSession
    
    // MARK: Init
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    // MARK: - JSON request
    
    func request<T: Codable>(url: URL, _ completion: @escaping ((Result<T, NetworkError>) -> Void)) {
        session.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self else {
                return
            }
            
            if let error = error {
                completion(.failure(.apiError(message: error.localizedDescription)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.emptyData))
                return
            }
            
            self.parse(for: data, completion)
        }.resume()
    }
    
    // MARK: - Data request
    
    func download(url: URL, _ completion: @escaping ((Result<Data, NetworkError>) -> Void)) {
        session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(.apiError(message: error.localizedDescription)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.emptyData))
                return
            }
            
            completion(.success(data))
        }.resume()
    }
    
    // MARK: - Parse data
    
    private func parse<T: Codable>(for data: Data, _ completion: @escaping ((Result<T, NetworkError>) -> Void)) {
        if let apiError = try? JSONDecoder().decode(APIError.self, from: data) {
            completion(.failure(.apiError(message: apiError.error)))
            return
        }
        
        do {
            let data: T = try JSONDecoder().decode(T.self, from: data)
            completion(.success(data))
        } catch {
            completion(.failure(.decodeError))
        }
    }
}
