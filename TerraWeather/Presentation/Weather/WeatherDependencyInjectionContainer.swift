//
//  WeatherDependencyInjectionContainer.swift
//  TerraWeather
//
//  Created by Ega Setya Putra on 21/09/24.
//

import UIKit

final class WeatherDependencyInjectionContainer {
    private let navigationController: UINavigationController
    private let weatherDetailPayload: WeatherDetailPayload
    
    init(navigationController: UINavigationController, weatherDetailPayload: WeatherDetailPayload) {
        self.navigationController = navigationController
        self.weatherDetailPayload = weatherDetailPayload
    }
    
    private func provideRepository() -> WeatherRepository {
        DefaultWeatherRepository()
    }
    
    private func provideViewModel() -> WeatherViewModel {
        DefaultWeatherViewModel(repository: provideRepository(), weatherDetailPayload: weatherDetailPayload)
    }
    
    func provideHomageCoordinator() -> WeatherCoordinator {
        DefaultWeatherCoordinator(navigationController: navigationController, dependencies: self)
    }
}

extension WeatherDependencyInjectionContainer: WeatherCoordinatorDependencies {
    func createWeatherViewController(actions: WeatherActions) -> UIViewController {
        WeatherViewController(actions: actions, viewModel: provideViewModel())
    }
}
