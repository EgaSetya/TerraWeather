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
            let response = try await NetworkProvider<LocationTargetType>()
                .request(.getProvinces, ProvincesResponse.self)
            
            return .success(response.data)
        } catch let error as NetworkError {
            return .failure(error)
        } catch {
            return .failure(.Unknown)
        }
    }
    
    func getCities() async -> Result<[City], NetworkError> {
        do {
            let response = try await NetworkProvider<LocationTargetType>()
                .request(.getCities, CitiesResponse.self)
            
            return .success(response.data)
        } catch let error as NetworkError {
            return .failure(error)
        } catch {
            return .failure(.Unknown)
        }
    }
}
