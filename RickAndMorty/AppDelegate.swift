//
//  AppDelegate.swift
//  RickAndMorty
//
//  Created by Kirill Riabinin on 26.10.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var serviceProvider = ServiceProvider()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        serviceProvider.addService(service: NetworkService())
        
        setupRootController()
        return true
    }
    
    func setupRootController() {
        let navigationController = UINavigationController()
        let router = Router(navigationController: navigationController, serviceProvider: serviceProvider)
        window?.rootViewController = router.makeRootController(for: .listOfHeroes)
    }
}
