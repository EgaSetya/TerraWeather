//
//  MainCoordinator.swift
//  TerraWeather
//
//  Created by Ega Setya Putra on 19/09/24.
//

import UIKit

public protocol MainCoordinator {
    var navigationController: UINavigationController { get }
    
    init(navigationController: UINavigationController)
    func start()
}

final class DefaultMainCoordinator: MainCoordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let homepageDIContainer = HomepageDependencyInjectionContainer(navigationController: navigationController)
        let homepageCoordinator = homepageDIContainer.provideHomageCoordinator()
        
        homepageCoordinator.start()
    }
}
