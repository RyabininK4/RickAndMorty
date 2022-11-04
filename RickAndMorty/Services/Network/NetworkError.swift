//
//  NetworkError.swift
//  RickAndMorty
//
//  Created by Kirill Riabinin on 26.10.2022.
//

import Foundation

enum NetworkError: Error, Equatable {
    case emptyData
    case apiError(message: String)
    case decodeError
    case urlError
    
    var message: String {
        switch self {
        case .decodeError:
            return "Decoding error"
        case .emptyData:
            return "Server response is missing required data"
        case .apiError(let message):
            return message
        case .urlError:
            return "URL address is invalid"
        }
    }
}
