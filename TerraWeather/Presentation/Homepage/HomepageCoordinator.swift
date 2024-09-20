//
//  HomepageCoordinator.swift
//  TerraWeather
//
//  Created by Ega Setya Putra on 19/09/24.
//

import UIKit

protocol HomepageCoordinatorDependencies {
    func createHomepageViewController(actions: HomepageActions) -> UIViewController
}

protocol HomepageCoordinator {
    var navigationController: UINavigationController { get }
    var dependencies: HomepageCoordinatorDependencies { get }
    
    init(navigationController: UINavigationController, dependencies: HomepageCoordinatorDependencies)
    
    func start()
}

final class DefaultHomepageCoordinator: HomepageCoordinator {
    var navigationController: UINavigationController
    var dependencies: HomepageCoordinatorDependencies
    
    init(navigationController: UINavigationController, dependencies: HomepageCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        let actions = HomepageActions(showWeatherDetail: showWeatherDetail)
        
        let viewController = dependencies.createHomepageViewController(actions: actions)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func showWeatherDetail() {
        print("Navigate to weather detail page")
    }
}
