//
//  NetworkProvider.swift
//  TerraWeather
//
//  Created by Ega Setya Putra on 19/09/24.
//

import Foundation

import Moya

public struct NetworkProvider<Target> where Target: TargetType {
    private let provider: MoyaProvider<Target>
    
    public init(
        endpointClosure: @escaping MoyaProvider<Target>.EndpointClosure = NetworkProvider.defaultEndpointCreator,
        requestClosure: @escaping MoyaProvider<Target>.RequestClosure = NetworkProvider.endpointResolver(),
        stubClosure: @escaping MoyaProvider<Target>.StubClosure = MoyaProvider.neverStub,
        callbackQueue: DispatchQueue? = nil,
        trackInflights: Bool = false,
        withBearerToken: Bool = true
    ) {
        provider = MoyaProvider(
            endpointClosure: endpointClosure,
            requestClosure: requestClosure,
            stubClosure: stubClosure,
            callbackQueue: callbackQueue,
            trackInflights: trackInflights
        )
    }
    
    public func request<D: Decodable>(
        _ token: Target,
        _ responseType: D.Type,
        atKeyPath keyPath: String? = nil,
        using decoder: JSONDecoder = JSONDecoder()
    ) async throws -> D {
        return try await withCheckedThrowingContinuation { continuation in
            provider.request(token) { result in
                switch result {
                case .failure(let error):
                    if isOffline(error: error) {
                        continuation.resume(throwing: NetworkError.Offline)
                    } else {
                        continuation.resume(throwing: NetworkError.Custom(message: "error", code: error.errorCode))
                    }
                case .success(let response):
                    do {
                        // Handle status code logic using the separated function
                        try handleHTTPStatusCode(response.statusCode, responseURL: response.response?.url)
                        
                        // Decode the response
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        
                        let value = try response.map(D.self, atKeyPath: keyPath, using: decoder, failsOnEmptyData: true)
                        continuation.resume(returning: value)
                    } catch let error {
                        continuation.resume(throwing: NetworkError.Decoding(error))
                    }
                }
            }
        }
    }
    
    private func handleHTTPStatusCode(_ statusCode: Int, responseURL: URL?) throws {
        switch statusCode {
        case 401:
            throw NetworkError.Unauthorized
        case 400...499:
            throw NetworkError.BadRequest(responseURL?.absoluteString ?? "")
        case 500:
            throw NetworkError.ServerError
        default:
            break
        }
    }
    
    private func isOffline(error: MoyaError) -> Bool {
        switch (error as NSError).code {
        case NSURLErrorCannotConnectToHost, NSURLErrorNotConnectedToInternet:
            return true
        default:
            return false
        }
    }
}
