//
//  UserViewModel.swift
//  TakeIt
//
//  Created by Parker on 7/10/23.
//

import Foundation
import Combine
import RealmSwift

class UserViewModel: ObservableObject {
    
    @Published var users: [User] = []
    
    @ObservedResults(User.self) var fetchedUsers
    
    private var network: Network
    
    init(network: Network) {
        self.network = network
    }

    func populateUsers() async throws {
        self.users = try await network.syncUsers()
    }
}

extension Network {
    func syncUsers() async throws -> [User]  {
        let endpoint = Endpoint.syncUsers
        let request = try endpoint.generateURLRequest()
 
        return try await self.request(with: request, decodable: [User].self)
    }
}
 
enum Endpoint: NetworkEndpoint {
    case syncUsers
    case syncUserPosts(userId: Int)
    case syncUserComments(userId: Int)
    
    var baseURL: URL {
        return URL(string: "https://jsonplaceholder.typicode.com")!
    }
    
    var path: String {
        switch self {
        case .syncUsers :
            return "/users"

        case .syncUserPosts(userId: let userId):
            return "/users/\(userId)/posts"

        case .syncUserComments(userId: let userId):
            return "/users/\(userId)/comments"
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
