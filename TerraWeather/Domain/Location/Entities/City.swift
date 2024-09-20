//
//  City.swift
//  TerraWeather
//
//  Created by Ega Setya Putra on 20/09/24.
//

struct CitiesResponse: Codable {
    let data: [City]
}

struct City: Codable {
    let id, name, altName: String
    let latitude, longitude: Double
    let provinceId: String
}
