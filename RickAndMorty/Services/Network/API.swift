//
//  API.swift
//  RickAndMorty
//
//  Created by Kirill Riabinin on 26.10.2022.
//

import Foundation

struct API {
    private static let url = "https://rickandmortyapi.com"
    private static let pageHeroes = "/api/character/?page="
    private static let heroDetails = "/api/character/"
    
    enum Endpoints {
        case pageHeroes(page: Int)
        case heroDetails(id: Int)
    }
    
    static func makeUrl(with endpoint: Endpoints) -> URL? {
        switch endpoint {
        case .pageHeroes(let page):
            return URL(string: url + pageHeroes + "\(page)")
        case .heroDetails(let id):
            return URL(string: url + heroDetails + "\(id)")
        }
    }
}
