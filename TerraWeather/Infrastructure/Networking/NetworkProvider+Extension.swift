//
//  NetworkProvider+Extension.swift
//  TerraWeather
//
//  Created by Ega Setya Putra on 20/09/24.
//

import Foundation

import Alamofire
import Moya

extension NetworkProvider {
    public static func endpointResolver() -> MoyaProvider<Target>.RequestClosure {
        return { (endpoint, closure) in
            let request = try! endpoint.urlRequest()
            closure(.success(request))
        }
    }
    
    public static func defaultEndpointCreator(for target: Target) -> Endpoint {
        let headers: [String: String] = [
            "Accept": "application/json",
            "Accept-Encoding": "gzip",
        ]
        
        var extraHeaders: [String: String] = [:]
        let newTask: Task
        if case let .requestParameters(targetParameters, encoding) = target.task {
            newTask = .requestParameters(parameters: targetParameters, encoding: encoding)
        } else {
            newTask = target.task
        }
        
        if let extraTargetHeader = target.headers {
            extraTargetHeader.forEach {
                extraHeaders.updateValue($1, forKey: $0)
            }
        }
        
        let defaultHeaders = Alamofire.HTTPHeaders.default.dictionary
        extraHeaders = extraHeaders.merging(defaultHeaders) { first, _ -> String in
            first
        }
        
        return Endpoint(
            url: target.baseURL.appendingPathComponent(target.path).absoluteString,
            sampleResponseClosure: { .networkResponse(200, target.sampleData) },
            method: target.method,
            task: newTask,
            httpHeaderFields: headers
        ).adding(newHTTPHeaderFields: extraHeaders)
    }
}
