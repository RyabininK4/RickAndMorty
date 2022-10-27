//
//  Router.swift
//  RickAndMorty
//
//  Created by Kirill Riabinin on 26.10.2022.
//

import UIKit

final class Router {
    
    enum Destination {
        case listOfHeroes
        case heroDetails(hero: Hero)
        case errorAlert(error: NetworkError)
    }
    
    // MARK: - Properties
    
    private weak var navigationController: UINavigationController?
    private var serviceProvider: ServiceProvider
    private var networkService: NetworkService? {
        return serviceProvider.getService()
    }
    
    // MARK: - Init
    
    init(navigationController: UINavigationController?, serviceProvider: ServiceProvider) {
        self.navigationController = navigationController
        self.serviceProvider = serviceProvider
    }
    
    // MARK: - Methods
    
    func navigate(to destination: Destination) {
        let viewController = makeViewController(for: destination)
        switch destination {
        case .errorAlert:
            navigationController?.present(viewController, animated: true)
        default:
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func makeRootController(for destination: Destination) -> UIViewController {
        let navigationController = self.navigationController ?? UINavigationController()
        navigationController.viewControllers = [makeViewController(for: destination)]
        return navigationController
    }
    
    // MARK: - Private methods
    
    private func makeViewController(for destination: Destination) -> UIViewController {
        switch destination {
        case .listOfHeroes:
            let storyboard = UIStoryboard(name: "ListOfHeroes", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "ListOfHeroesViewController") as!
            ListOfHeroesViewController
            if let networkService = networkService {
                controller.configure(with: ListOfHeroesViewModel(networkService: networkService))
            }
            return controller
        case .heroDetails(let hero):
            let storyboard = UIStoryboard(name: "HeroDetails", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "HeroDetailsViewController") as! HeroDetailsViewController
            if let networkService = networkService {
                controller.configure(with: HeroDetailViewModel(hero: hero, networkService: networkService))
            }
            return controller
        case .errorAlert(let error):
            let alert = UIAlertController(title: "Error", message: error.message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            return alert
        }
    }
}
