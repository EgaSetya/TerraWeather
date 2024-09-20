//
//  NetworkError.swift
//  TerraWeather
//
//  Created by Ega Setya Putra on 19/09/24.
//

import Foundation

public enum NetworkError: Error {
    case ServerError
    case BadRequest(String)
    case URLFailure
    case Decoding(Error)
    case Offline
    case Custom(message: String, code: Int)
    case Unknown
    case Unauthorized
    
}

extension NetworkError: LocalizedError {
    /**
         Returns a localized description of the error, depending on the case.
         */
    public var errorDescription: String? {
        switch self {
        case .Unknown:
            "An unknown error occurred."
        case let .Custom(message, status):
            "\(status), \(message)"
        case .BadRequest(let parameters): // 400
            "Request is invalid - \(parameters)"
        case .ServerError: // 500
            "Server encountered a problem.\nPlease try again in a moment!"
        case .Offline: // 1009
            "Your Internet connection is offline.\nPlease check your network status."
        case .URLFailure:
            "URL not valid"
        case .Decoding(let error):
            "Failed to decode - \(error.localizedDescription)"
        case .Unauthorized:
            "Unauthorized"
        }
    }
}
