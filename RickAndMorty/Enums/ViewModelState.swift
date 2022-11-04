//
//  ViewModelState.swift
//  RickAndMorty
//
//  Created by Kirill Riabinin on 04.11.2022.
//

import Foundation

enum ViewModelState: Equatable {
    case loading
    case finished
    case error(NetworkError)
}
