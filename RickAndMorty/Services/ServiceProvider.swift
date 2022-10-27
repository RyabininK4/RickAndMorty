//
//  ServiceProvider.swift
//  RickAndMorty
//
//  Created by Kirill Riabinin on 26.10.2022.
//

import UIKit

class ServiceProvider {
    
    private lazy var reg: [String: AnyObject] = [:]
    
    func addService<T>(service: T) {
        let key = "\(type(of: service))"
        reg[key] = service as AnyObject
    }
    
    func getService<T>() -> T? {
        let key = "\(T.self)"
        return reg[key] as? T
    }
}

extension ServiceProvider {
    static var shared: ServiceProvider {
        return (UIApplication.shared.delegate as? AppDelegate)?.serviceProvider ?? ServiceProvider()
    }
}
