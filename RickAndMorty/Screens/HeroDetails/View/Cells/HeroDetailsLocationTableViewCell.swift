//
//  HeroDetailsLocationTableViewCell.swift
//  RickAndMorty
//
//  Created by Kirill Riabinin on 26.10.2022.
//

import UIKit

final class HeroDetailsLocationTableViewCell: UITableViewCell {

    // MARK: - Outlets
    
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var subtitleLabel: UILabel!
    
    // MARK: - Setup
    
    func setup(location: Location) {
        titleLabel.text = location.name
        subtitleLabel.text = location.type
    }
}
