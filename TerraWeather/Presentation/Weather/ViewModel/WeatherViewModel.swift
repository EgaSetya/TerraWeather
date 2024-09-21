//
//  WeatherViewModel.swift
//  TerraWeather
//
//  Created by Ega Setya Putra on 21/09/24.
//

import Foundation

import Combine

struct WeatherItemViewModel {
    let username: String
    let city: String
    let temperature: Double
    let weatherDescription: String
    let highTemperature: Double
    let lowTemperature: Double
    let day: String?
    let iconURL: URL?
}

protocol WeatherViewModel: WeatherViewModelInput, WeatherViewModelOutput {}

protocol WeatherViewModelInput {
    init(repository: WeatherRepository, weatherDetailPayload: WeatherDetailPayload)
    
    func viewWillAppear()
    func refresh()
}

protocol WeatherViewModelOutput {
    var shouldRefresh: AnyPublisher<Void, Never> { get }
    var viewState: WeatherViewState { get }
    
    var currentWeatherItemViewModel: WeatherItemViewModel? { get }
    var forecastItemViewModels: [WeatherItemViewModel] { get }
}

// MARK: DefaultWeatherViewModel
final class DefaultWeatherViewModel: WeatherViewModel {
    var viewState: WeatherViewState = .idle
    var currentWeatherItemViewModel: WeatherItemViewModel?
    var forecastItemViewModels: [WeatherItemViewModel] = []
    
    private let _shouldRefresh = CurrentValueSubject<Void, Never>(())
    private let repository: WeatherRepository
    private let weatherDetailPayload: WeatherDetailPayload
    
    init(repository: WeatherRepository, weatherDetailPayload: WeatherDetailPayload) {
        self.repository = repository
        self.weatherDetailPayload = weatherDetailPayload
    }
    
    private func getCurrrentWeather() async {
        updateViewState(.loading)
        
        let result = await repository.getCurrentWeather(payload: weatherDetailPayload.payload)
        
        switch result {
        case .success(let currentWeather):
            handleCurrentWeatherData(currentWeather)
        case .failure(let failure):
            handleRequestError(failure)
        }
    }
    
    private func getForecast() async {
        updateViewState(.loading)
        
        let result = await repository.getFiveDaysForecast(payload: weatherDetailPayload.payload)
        
        switch result {
        case .success(let forecastData):
            handleForecastData(forecastData)
        case .failure(let failure):
            handleRequestError(failure)
        }
    }
    
    private func getWeatherData() {
        Task {
            await getCurrrentWeather()
            await getForecast()
            
            updateViewState(.dataRetrieved)
        }
    }
    
    private func updateViewState(_ newState: WeatherViewState) {
        viewState = newState
        _shouldRefresh.send()
    }
    
    private func handleCurrentWeatherData(_ data: CurrentWeather) {
        currentWeatherItemViewModel = WeatherItemViewModel(
            username: weatherDetailPayload.username,
            city: weatherDetailPayload.city,
            temperature: data.main.temp,
            weatherDescription: data.weather.first?.description ?? "",
            highTemperature: data.main.tempMax,
            lowTemperature: data.main.tempMin,
            day: nil,
            iconURL: nil
        )
    }
    
    private func handleForecastData(_ data: Forecast) {
        forecastItemViewModels = data.list.compactMap { forecast in
            WeatherItemViewModel(
                username: "",
                city: "",
                temperature: forecast.main.temp,
                weatherDescription: (forecast.weather.first?.description ?? "").uppercased(),
                highTemperature: forecast.main.tempMax,
                lowTemperature: forecast.main.tempMin,
                day: getDayOfWeek(from: forecast.dt), 
                iconURL: getIconURL(with: forecast.weather.first?.icon ?? "")
            )
        }
    }
    
    private func handleRequestError(_ failure: NetworkError) {
        if failure == NetworkError.Offline {
            updateViewState(.connectionError(message: failure.errorDescription ?? ""))
            return
        }
        
        updateViewState(.error(message: failure.errorDescription ?? ""))
    }
    
    func getDayOfWeek(from timestamp: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
            
            let calendar = Calendar.current
            let today = calendar.startOfDay(for: Date())
            let isToday = calendar.isDate(date, inSameDayAs: today)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"

            let timeString = dateFormatter.string(from: date)
            
            dateFormatter.dateFormat = "EEEE"
            let dayName = dateFormatter.string(from: date).uppercased()
            
            if isToday {
                return "TODAY - \(timeString)"
            } else {
                return "\(dayName) - \(timeString)"
            }
    }
    
    func getIconURL(with iconName: String) -> URL? {
        URL(string: "https://openweathermap.org/img/wn/\(iconName)@2x.png")
    }
}

// MARK: WeatherViewModelInput
extension DefaultWeatherViewModel {
    func viewWillAppear() {
        getWeatherData()
    }
    
    func refresh() {
        getWeatherData()
    }
}

// MARK: WeatherViewModelOutput
extension DefaultWeatherViewModel {
    var shouldRefresh: AnyPublisher<Void, Never> {
        _shouldRefresh.eraseToAnyPublisher()
    }
}
