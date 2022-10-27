//
//  BaseViewController.swift
//  RickAndMorty
//
//  Created by Kirill Riabinin on 26.10.2022.
//

import UIKit

class BaseViewController: UIViewController {
    
    // MARK: - UI components
    
    private var activityIndicator = UIActivityIndicatorView()
    
    // MARK: - Properties
    
    lazy var router = Router(navigationController: navigationController, serviceProvider: ServiceProvider.shared)
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureActivityIndicator()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        updatePositionActivityIndicator()
    }
    
    // MARK: - UIActivityIndicator
    
    private func configureActivityIndicator() {
        activityIndicator.style = .large
        self.view.addSubview(activityIndicator)
        updatePositionActivityIndicator()
    }
    
    private func updatePositionActivityIndicator() {
        activityIndicator.center = self.view.center
    }
    
    
    func startActivity() {
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
    }
    
    func stopActivity() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    
    // MARK: - Error alert
    
    func showError(_ error: NetworkError) {
        router.navigate(to: .errorAlert(error: error))
    }
}
