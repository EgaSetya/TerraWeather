//
//  CurrentWeather.swift
//  TerraWeather
//
//  Created by Ega Setya Putra on 20/09/24.
//

import Foundation

// MARK: - WeatherResponse
struct CurrentWeather: Codable {
    let coord: Coord
    let weather: [Weather]
    let main: Main
    let dt: Int
    let timezone, id: Int
    let name: String
    let cod: Int
}

// MARK: - Coord
struct Coord: Codable {
    let lon, lat: Double
}

// MARK: - Main
struct Main: Codable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, humidity, seaLevel, grndLevel: Int

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike
        case tempMin
        case tempMax
        case pressure, humidity
        case seaLevel
        case grndLevel
    }
}

// MARK: - Weather
struct Weather: Codable {
    let id: Int
    let main, description, icon: String
}
