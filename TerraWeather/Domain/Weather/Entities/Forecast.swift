//
//  Forecast.swift
//  TerraWeather
//
//  Created by Ega Setya Putra on 20/09/24.
//

import Foundation

// MARK: - ForecastResponse
struct Forecast: Codable {
    let cod: String
    let message, cnt: Int
    let list: [List]
}

// MARK: - List
struct List: Codable {
    let dt: Int
    let main: Main
    let weather: [Weather]
    let visibility: Int
    let pop: Double
    let dtTxt: String

    enum CodingKeys: String, CodingKey {
        case dt, main, weather, visibility, pop
        case dtTxt
    }
}
