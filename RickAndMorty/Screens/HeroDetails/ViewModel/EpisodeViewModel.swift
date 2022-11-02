//
//  EpisodeViewModel.swift
//  RickAndMorty
//
//  Created by Kirill Riabinin on 26.10.2022.
//

import Foundation

final class EpisodeViewModel {
    
    // MARK: - Private properties
    
    private var episode: Episode
    
    // MARK: - Init
    
    init(for episode: Episode) {
        self.episode = episode
    }
    
    // MARK: - Properties
    
    var title: String {
        return [episode.episode, episode.name].compactMap({ $0 }).joined(separator: " / ")
    }
    
    var titleLink: String {
        return "\nWatch in browser"
    }
    
    var url: URL? {
        return URL(string: episode.url)
    }
}
