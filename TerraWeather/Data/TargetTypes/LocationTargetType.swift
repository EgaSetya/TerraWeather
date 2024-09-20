//
//  LocationTargetType.swift
//  TerraWeather
//
//  Created by Ega Setya Putra on 20/09/24.
//

import Foundation

import Moya

enum LocationTargetType {
    case getProvinces
    case getCities
}

extension LocationTargetType: TargetType {
    var baseURL: URL { URL(string: "https://api.npoint.io/")! }
    
    var path: String {
        switch self {
        case .getProvinces: "4280ee999caacea0c8f0"
        case .getCities: "f6547f81bdb1d04dd670"
        }
    }
    
    var method: Moya.Method { .get }
    
    var task: Moya.Task { .requestParameters(parameters: [:], encoding: URLEncoding.default) }
    
    var headers: [String : String]? { nil }
}
