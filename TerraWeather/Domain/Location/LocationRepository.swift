//
//  LocationRepository.swift
//  TerraWeather
//
//  Created by Ega Setya Putra on 20/09/24.
//

protocol LocationRepository {
    func getProvinces() async -> Result<[Province], NetworkError>
    func getCities() async -> Result<[City], NetworkError>
}
