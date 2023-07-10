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
    
    /// Returns a <Decodable> from URL session data task for a given router.
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
