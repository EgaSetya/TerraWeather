//
//  WeatherTargetType.swift
//  TerraWeather
//
//  Created by Ega Setya Putra on 20/09/24.
//

import Foundation

import Moya

enum WeatherTargetType {
    case getCurrentWeather(payload: WeatherPayload)
    case getFiveDaysForecast(payload: WeatherPayload)
}

extension WeatherTargetType: TargetType {
    var baseURL: URL { URL(string: "https://api.openweathermap.org/data/2.5/")! }
    
    var path: String {
        
        switch self {
        case .getCurrentWeather: 
            return "weather"
        case .getFiveDaysForecast:
            return "forecast"
        }
    }
    
    var method: Moya.Method { .get }
    
    var task: Moya.Task {
        var parameters: [String: Any] {
            let ApiKey = "6c9b4e2ae88a4e8492b3fef4df4e9488"
            
            switch self {
            case .getCurrentWeather(let payload):
                return [
                    "lat": payload.lat,
                    "lon": payload.long,
                    "appid": ApiKey,
                    "units": "metric"
                ]
            case .getFiveDaysForecast(let payload):
                return [
                    "lat": payload.lat,
                    "lon": payload.long,
                    "appid": ApiKey,
                    "units": "metric"
                ]
            }
        }
        
        return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
    }
    
    var headers: [String : String]? { nil }
}
