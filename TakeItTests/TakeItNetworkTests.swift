//
//  TakeItNetworkTests.swift
//  TakeItTests
//
//  Created by Parker on 7/10/23.
//

import XCTest
@testable import TakeIt

final class TakeItNetworkTests: XCTestCase {
 
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        URLProtocol.registerClass(URLProtocolMock.self)

    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        URLProtocol.unregisterClass(URLProtocolMock.self)

    }

    func testMockNetworkGetDataTaskRequest() async throws {
        let mockPost = """
         {
             "userId": 1,
             "id": 1,
             "title": "sunt aut facere repellat",
             "body": "quia et suscipit"
         }
        """
        let endpoint = MockEndpoint.getMockData
        let request = try! endpoint.generateURLRequest()
        URLProtocolMock.urls[request.url!] = StubbedResponse(response: HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!, data: mockPost.data(using: .utf8)!)
 
        let network = Network.init()
        let post = try await network.request(with: request, decodable: Post.self)
        XCTAssertNotNil(post)
    }
    
    func testFailedMockNetworkGetDataTaskRequest() async throws {
        let mockPost = """
         {
             "userId": 1,
             "id": 1,
             "title": "sunt aut facere repellat",
             "body": "quia et suscipit"
         }
        """
        let endpoint = MockEndpoint.getMockData
        let request = try! endpoint.generateURLRequest()
        URLProtocolMock.urls[request.url!] = StubbedResponse(response: HTTPURLResponse(url: request.url!, statusCode: 404, httpVersion: nil, headerFields: nil)!, data: mockPost.data(using: .utf8)!)
        
        let network = Network.init()
        do {
            let post = try await network.request(with: request, decodable: Post.self)
            XCTAssertNil(post)
        } catch {
            XCTAssertNotNil(error)
        }
    }
}


/// Mock use case of building an endpoint/test 
enum MockEndpoint: NetworkEndpoint {
    case getMockData
    
    var baseURL: URL {
        return URL(string: "http://www.example.com/api/v3")!
    }
    
    var path: String {
        switch self {
        case .getMockData :
            return "/data/"
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
    
    var authenticationHeader: HTTPParameters? {
        switch self {
        default:
            return nil
        }
    }
     
    var httpMethod: HTTPMethod {
        switch self {
        default:
            return .get
        }
    }
}
