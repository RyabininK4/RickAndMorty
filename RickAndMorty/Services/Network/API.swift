//
//  API.swift
//  RickAndMorty
//
//  Created by Kirill Riabinin on 26.10.2022.
//

import Foundation

struct API {
    private static let url = "https://rickandmortyapi.com"
    private static let character = "/api/character"
    
    enum Endpoints {
        case firstPageHeroes
        case heroes(page: Int)
        case heroDetails(id: Int)
    }
    
    static func makeUrl(with endpoint: Endpoints) -> URL? {
        switch endpoint {
        case .firstPageHeroes:
            return URL(string: url + character)
        case .heroes(let page):
            var urlComponents = URLComponents(string: url + character)
            let queryItem = URLQueryItem(name: "page", value: "\(page)")
            urlComponents?.queryItems = [queryItem]
            return urlComponents?.url
        case .heroDetails(let id):
            return URL(string: url + character + "/\(id)")
        }
    }
}
