//
//  WeatherCoordinator.swift
//  TerraWeather
//
//  Created by Ega Setya Putra on 21/09/24.
//

import UIKit

protocol WeatherCoordinatorDependencies {
    func createWeatherViewController(actions: WeatherActions) -> UIViewController
}

protocol WeatherCoordinator {
    var navigationController: UINavigationController { get }
    var dependencies: WeatherCoordinatorDependencies { get }
    
    init(navigationController: UINavigationController, dependencies: WeatherCoordinatorDependencies)
    
    func start()
}

final class DefaultWeatherCoordinator: WeatherCoordinator {
    var navigationController: UINavigationController
    var dependencies: WeatherCoordinatorDependencies
    
    init(navigationController: UINavigationController, dependencies: WeatherCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        let actions = WeatherActions(showErrorAlert: showErrorAlert)
        
        let viewController = dependencies.createWeatherViewController(actions: actions)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func showErrorAlert(_ type: PopupAlertType, _ retryDidTap: (() -> Void)?) {
        let viewController = PopupAlertViewController(type: type, retryDidTap: retryDidTap)
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.modalTransitionStyle = .crossDissolve
        
        navigationController.present(viewController, animated: true)
    }
}
