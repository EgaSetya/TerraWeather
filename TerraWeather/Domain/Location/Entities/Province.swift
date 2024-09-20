//
//  Province.swift
//  TerraWeather
//
//  Created by Ega Setya Putra on 20/09/24.
//

struct ProvincesResponse: Codable {
    let data: [Province]
}

struct Province: Codable {
    let id, name, altName: String
    let latitude, longitude: Double
}
