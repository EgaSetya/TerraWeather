//
//  DefaultLocationRepository.swift
//  TerraWeather
//
//  Created by Ega Setya Putra on 20/09/24.
//

import Foundation

final class DefaultLocationRepository: LocationRepository {
    func getProvinces() async -> Result<[Province], NetworkError> {
        do {
            // Make the network request using the refactored request function
            let response = try await NetworkProvider<LocationTargetType>()
                .request(.getProvinces, ProvincesResponse.self)
            
            // Assuming ProvincesResponse has a property `provinces` that contains the array of provinces
            return .success(response.data)
        } catch let error as NetworkError {
            // Handle network-related errors
            return .failure(error)
        } catch {
            // Handle unexpected errors
            return .failure(.Unknown)
        }
    }
    
    func getCities() async -> Result<[City], NetworkError> {
        do {
            // Make the network request using the refactored request function
            let response = try await NetworkProvider<LocationTargetType>()
                .request(.getCities, CitiesResponse.self)
            
            // Assuming ProvincesResponse has a property `provinces` that contains the array of provinces
            return .success(response.data)
        } catch let error as NetworkError {
            // Handle network-related errors
            return .failure(error)
        } catch {
            // Handle unexpected errors
            return .failure(.Unknown)
        }
    }
}
