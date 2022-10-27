//
//  UIImageView+Extensions.swift
//  RickAndMorty
//
//  Created by Kirill Riabinin on 26.10.2022.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    // MARK: - UI
    
    func setCorner(radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
    // MARK: - Download image
    
    func set(urlString: String?) {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            return
        }
        image = nil
        
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) {
            image = imageFromCache as? UIImage
            return
        }
        
        guard let networkService: NetworkService = ServiceProvider.shared.getService() else {
            return
        }
        
        networkService.download(url: url) { [weak self] result in
            guard let self = self else {
                return
            }
            
            switch result {
            case .failure(_):
                break
            case .success(let data):
                guard let imageToCache = UIImage(data: data) else {
                    return
                }
                DispatchQueue.main.async {
                    imageCache.setObject(imageToCache, forKey: urlString as AnyObject)
                    self.image = UIImage(data: data)
                }
            }
        }
    }
}
