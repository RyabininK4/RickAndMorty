//
//  Hero.swift
//  RickAndMorty
//
//  Created by Kirill Riabinin on 26.10.2022.
//

import Foundation

struct Hero: Codable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let type: String
    let gender: String
    let location: Location
    let image: String
    let episode: [String]
}
