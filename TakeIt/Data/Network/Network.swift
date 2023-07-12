//
//  Network.swift
//  TakeIt
//
//  Created by Parker on 7/10/23.
//

import Foundation
import Combine
 
protocol NetworkEngine {
    func request<D: Decodable>(with endpointRequest: URLRequest, decodable type: D.Type) async throws -> D
}
 
public struct Network: NetworkEngine {
    public var session: URLSession
    public let decoder: JSONDecoder
        
    public init(session: URLSession = .shared, decoder: JSONDecoder = JSONDecoder.init()) {
        self.session = session
        self.decoder = decoder
    }
    
    /// Returns a <Decodable> from URL session data task for a given endpoint.
    ///
    /// - Parameters:
    ///   - endpoint: NetworkEndpoint.
    ///   - D: Decodable.
    /// - Returns: The <Decodable> of a dataTask or throws a NetworkError.
    public func request<D: Decodable>(with endpointRequest: URLRequest, decodable type: D.Type) async throws -> D {
        do {
            let (data, urlResponse) = try await session.data(for: endpointRequest)
            guard let httpResponse = urlResponse as? HTTPURLResponse,
                  isExpectedResponse(httpResponse.statusCode)
            else {
                let httpResponse = urlResponse as? HTTPURLResponse
                throw NetworkError.invalidServerResponseWith(statusCode: httpResponse?.statusCode ?? 0, response: httpResponse)
            }
            let decodedData = try decoder.decode(D.self, from: data)
            return decodedData
        } catch let urlError as URLError {
            throw NetworkError.sessionError(urlError)
        } catch {
            switch error {
            case is Swift.DecodingError:
                throw NetworkError.decodingError(error)
            case let error as NetworkError:
                throw error
            default:
                throw NetworkError.unknownFailure(error)
            }
        }
    }
 
    /// Returns `true` if `code` is in the 200..<300 range.
    private func isExpectedResponse(_ statusCode: Int) -> Bool {
        return (200..<300).contains(statusCode)
    }
    
}
 
extension Network {
    /// Generates a `URLRequest` that returns a `[User]` from `Network`
    /// - Returns: `[User]`
    func syncUsers() async throws -> [User]  {
        let endpoint = Endpoint.syncUsers
        let request = try endpoint.generateURLRequest()
 
        return try await self.request(with: request, decodable: [User].self)
    }
    
    /// Generates a `URLRequest` that returns a `[Post]` from `Network`
    /// - Returns: `[Post]`
    func syncPosts() async throws -> [Post]  {
        let endpoint = Endpoint.syncPosts
        let request = try endpoint.generateURLRequest()

        return try await self.request(with: request, decodable: [Post].self)
    }
    
    /// Generates a `URLRequest` that returns a `[Comment]` from `Network`
    /// - Returns: `[Comment]`
    func syncComments() async throws -> [Comment]  {
        let endpoint = Endpoint.syncComments
        let request = try endpoint.generateURLRequest()

        return try await self.request(with: request, decodable: [Comment].self)
    }
}
 
enum Endpoint: NetworkEndpoint {
    case syncUsers
    case syncPosts
    case syncComments
    
    var baseURL: URL {
        return URL(string: "https://jsonplaceholder.typicode.com")!
    }
    
    var path: String {
        switch self {
        case .syncUsers :
            return "/users"

        case .syncPosts :
            return "/posts"

        case .syncComments:
            return "/comments"
        }
    }
    
    var queryItems: HTTPParameters? {
        return nil
    }
    
    var bodyParameters: HTTPParameters? {
        return nil
    }
    
    var contentType: ContentType {
        return .json
    }
    
    var headers: [String : String]? {
        return nil
    }
     
    var httpMethod: HTTPMethod {
        switch self {
        default:
            return .get
        }
    }
}
