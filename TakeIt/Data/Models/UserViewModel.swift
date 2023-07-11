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
    
    private var network: Network
    private var database: Database
    
    init(network: Network, database: Database) {
        self.network = network
        self.database = database
    }
    
    @MainActor
    func populateUsers() async throws {
        let users = try await network.syncUsers()
        
        database.realm.writeAsync {
            self.database.realm.add(users, update: .all)
        } onComplete: { error in
            if let error = error {
                print(error)
            } else {
               print("Added users")
            }
        }
        try await populatePosts()
        try await populateComments()
    }
    
    @MainActor
    func populatePosts() async throws {
        let posts = try await network.syncPosts()
        let users = database.realm.objects(User.self)
        
        // keys are userIds
        let userDictionary = Dictionary(uniqueKeysWithValues: users.map { ($0.id, $0) })
        
        database.realm.writeAsync {
            self.database.realm.add(posts, update: .all)
            posts.forEach { post in
                // find user in the dictionary instead of querying Realm
                if let user = userDictionary[post.userId] {
                    user.posts.append(post)
                }
            }
        } onComplete: { error in
            if let error = error {
                print(error)
            } else {
                print("Added posts")
            }
        }
    }
    
    @MainActor
    func populateComments() async throws {
        let comments = try await network.syncComments()
        let posts = database.realm.objects(Post.self)
        
        // keys are postIds
        let postDictionary = Dictionary(uniqueKeysWithValues: posts.map { ($0.id, $0) })

        database.realm.writeAsync {
            self.database.realm.add(comments, update: .all)
            comments.forEach { comment in
                // find post in the dictionary instead of querying Realm
                if let post = postDictionary[comment.postId] {
                    post.comments.append(comment)
                }
            }
        } onComplete: { error in
            if let error = error {
                print(error)
            } else {
                print("Added comments")
            }
        }
    }
}
