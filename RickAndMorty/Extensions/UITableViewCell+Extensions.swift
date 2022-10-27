//
//  UITableViewCell+Extensions.swift
//  RickAndMorty
//
//  Created by Kirill Riabinin on 26.10.2022.
//

import UIKit

extension UITableViewCell {
    
    static func create(for tableView: UITableView) -> UITableViewCell? {
        let className = String(describing: self)
        var cell: UITableViewCell?
        
        cell = tableView.dequeueReusableCell(withIdentifier: className)
        
        if cell == nil {
            cell = Bundle.main.loadNibNamed(className, owner: self, options: nil)?.first as? UITableViewCell
            let cellNib = UINib(nibName: className, bundle: nil)
            tableView.register(cellNib, forCellReuseIdentifier: className)
        }
        
        return cell
    }
}
