//
//  HomepageDependencyInjectionContainer.swift
//  TerraWeather
//
//  Created by Ega Setya Putra on 19/09/24.
//

import UIKit

final class HomepageDependencyInjectionContainer {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    private func provideRepository() -> LocationRepository {
        DefaultLocationRepository()
    }
    
    private func provideViewModel() -> HomepageViewModel {
        DefaultHomepageViewModel(repository: provideRepository())
    }
    
    func provideHomageCoordinator() -> HomepageCoordinator {
        DefaultHomepageCoordinator(navigationController: navigationController, dependencies: self)
    }
}

extension HomepageDependencyInjectionContainer: HomepageCoordinatorDependencies {
    func createHomepageViewController(actions: HomepageActions) -> UIViewController {
        HomepageViewController(actions: actions, viewModel: provideViewModel())
    }
}
