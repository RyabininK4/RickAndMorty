//
//  HeroDetailsNameTableViewCell.swift
//  RickAndMorty
//
//  Created by Kirill Riabinin on 26.10.2022.
//

import UIKit

final class HeroDetailsNameTableViewCell: UITableViewCell {

    // MARK: - Outlets
    
    @IBOutlet private var heroImageView: UIImageView!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var genderLabel: UILabel!
    @IBOutlet private var statusLabel: UILabel!
    @IBOutlet private var typeLabel: UILabel!
    
    // MARK: - Constans
    
    private struct Constants {
        static let radius: CGFloat = 12
    }

    // MARK: - Setup
    
    func setup(hero: Hero?) {
        guard let hero = hero else {
            return
        }
        nameLabel.text = hero.name
        genderLabel.text = hero.gender
        statusLabel.text = hero.status
        typeLabel.text = hero.type
        heroImageView.set(urlString: hero.image)
        heroImageView.setCorner(radius: Constants.radius)
    }
}
