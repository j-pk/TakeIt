//
//  NetworkEndpoint.swift
//  TakeIt
//
//  Created by Parker on 7/10/23.
//

import Foundation
  
public typealias HTTPParameters = [String: Any]

// MARK: HTTPMethod
public enum HTTPMethod: String {
    case get     = "GET" 
}

// MARK: Content Types
public enum ContentType: String {
    case json = "application/json"
}
 
// MARK: Network Error Enum
public enum NetworkError: Error, LocalizedError {
    case requestGenerationFailed
    case invalidServerResponseWith(statusCode: Int, response: HTTPURLResponse?)
    case decodingError(Error)
    case sessionError(Error)
    case unknownFailure(Error)
    
    public var errorDescription: String? {
        switch self {
        default:
            return ""
        }
    }
}

// MARK: NetworkEndpoint
/// Network Request protocol for urlRequest generation
/// Define values in a conformed enum to create a router/endpoint
public protocol NetworkEndpoint {
    var baseURL: URL { get }
    var path: String { get }
    var queryItems: HTTPParameters? { get }
    var bodyParameters: HTTPParameters? { get }
    var httpMethod: HTTPMethod { get }
    var contentType: ContentType { get }
    var headers: [String: String]? { get }
}

extension NetworkEndpoint {
    /// Transforms an NetworkEndpoint into a standard URL request
    /// Handles encoding for JSON and URL within the request
    public func generateURLRequest() throws -> URLRequest {
        guard var components = URLComponents(string: baseURL.absoluteString) else { throw NetworkError.requestGenerationFailed }
        components.path = components.path + path
        // QueryItems
        if let queryItems = queryItems {
            var items: [URLQueryItem] = []
            for (key, value) in queryItems {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                items.append(queryItem)
            }
            components.queryItems = items
        }
        guard let url = components.url else { throw NetworkError.requestGenerationFailed }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
 
        // Headers
        if let headers = headers {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        // Parameters
        if let bodyParameters = bodyParameters {
            request.httpBody = try? JSONSerialization.data(withJSONObject: bodyParameters, options: [])
        }
        request.setValue(contentType.rawValue, forHTTPHeaderField: "Content-Type")
        return request
    }
}



