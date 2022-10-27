//
//  HeroTableViewCell.swift
//  RickAndMorty
//
//  Created by Kirill Riabinin on 26.10.2022.
//

import UIKit

final class HeroTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet private var heroImageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var subtitleLabel: UILabel!
    
    // MARK: - Constans
    
    private struct Constants {
        static let radius: CGFloat = 16
    }

    // MARK: - Setup
    
    func setup(hero: Hero) {
        titleLabel.text = hero.name
        subtitleLabel.text = hero.status
        heroImageView.set(urlString: hero.image)
        heroImageView.setCorner(radius: Constants.radius)
    }
}
