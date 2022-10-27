//
//  HeroDetailsEpisodeTableViewCell.swift
//  RickAndMorty
//
//  Created by Kirill Riabinin on 26.10.2022.
//

import UIKit

final class HeroDetailsEpisodeTableViewCell: UITableViewCell {

    // MARK: - Outlets
    
    @IBOutlet private var textView: UITextView!
    
    // MARK: - Setup
    
    func setup(with episodeViewModel: EpisodeViewModel) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 15
        let descAttributed = NSMutableAttributedString(string: episodeViewModel.title, attributes: [.font: UIFont.systemFont(ofSize: 15, weight: .regular)])
        if let url = episodeViewModel.url {
            let linkText = NSMutableAttributedString(string: episodeViewModel.titleLink, attributes: [.link: url, .font: UIFont.systemFont(ofSize: 15, weight: .semibold), .paragraphStyle: paragraphStyle])
            descAttributed.append(linkText)
        }
        textView.attributedText = descAttributed
    }
}
