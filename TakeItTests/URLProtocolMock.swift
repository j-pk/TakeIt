//
//  URLProtocolMock.swift
//  TakeItTests
//
//  Created by Parker on 7/10/23.
//

import Foundation
 
struct StubbedResponse {
    let response: HTTPURLResponse
    let data: Data
}

/// `URLProtocolMock` class is a custom URL protocol that allows us to intercept network requests and provide our own stubbed responses from the `StubbedResponse` struct. 
class URLProtocolMock: URLProtocol {
    static var urls = [URL: StubbedResponse]()

    override class func canInit(with request: URLRequest) -> Bool {
        guard let url = request.url else { return false }
        return urls.keys.contains(url)
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        guard let client = client, let url = request.url, let stub = URLProtocolMock.urls[url] else {
            fatalError()
        }

        client.urlProtocol(self, didReceive: stub.response, cacheStoragePolicy: .notAllowed)
        client.urlProtocol(self, didLoad: stub.data)
        client.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() { }
}
