//
//  DefaultWeatherRepository.swift
//  TerraWeather
//
//  Created by Ega Setya Putra on 21/09/24.
//

import Foundation

final class DefaultWeatherRepository: WeatherRepository {
    func getCurrentWeather(payload: WeatherPayload) async -> Result<CurrentWeather, NetworkError> {
        do {
            let response = try await NetworkProvider<WeatherTargetType>()
                .request(.getCurrentWeather(payload: payload), CurrentWeather.self)
            
            return .success(response)
        } catch let error as NetworkError {
            return .failure(error)
        } catch {
            return .failure(.Unknown)
        }
    }
    
    func getFiveDaysForecast(payload: WeatherPayload) async -> Result<Forecast, NetworkError> {
        do {
            let response = try await NetworkProvider<WeatherTargetType>()
                .request(.getFiveDaysForecast(payload: payload), Forecast.self)
            
            return .success(response)
        } catch let error as NetworkError {
            return .failure(error)
        } catch {
            return .failure(.Unknown)
        }
    }
}
