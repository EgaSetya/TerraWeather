//
//  WeatherRepository.swift
//  TerraWeather
//
//  Created by Ega Setya Putra on 20/09/24.
//

protocol WeatherRepository {
    func getCurrentWeather(payload: WeatherPayload) async -> Result<CurrentWeather, NetworkError>
    func getFiveDaysForecast(payload: WeatherPayload) async -> Result<Forecast, NetworkError>
}
