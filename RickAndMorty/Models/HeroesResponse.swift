//
//  HeroesResponse.swift
//  RickAndMorty
//
//  Created by Kirill Riabinin on 26.10.2022.
//

import Foundation

struct HeroesResponse: Codable {
    let info: Info
    let results: [Hero]
}
