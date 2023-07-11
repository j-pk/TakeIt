//
//  TakeItTests.swift
//  TakeItTests
//
//  Created by Parker on 7/10/23.
//

import XCTest
import RealmSwift
import Combine
@testable import TakeIt

final class TakeItTests: XCTestCase {
    
    private let database = Database()
    private var subscriptions = Set<AnyCancellable>()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        // https://www.mongodb.com/docs/realm/sdk/swift/test-and-debug/
        // Use an in-memory Realm identified by the name of the current test.
        // This ensures that each test can't accidentally access or modify the data
        // from other tests or the application itself, and because they're in-memory,
        // there's nothing that needs to be cleaned up.
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = UUID().uuidString
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testUserRealmCodable() throws {
        let mockUserData = """
        {
            "id": 2,
            "name": "Ervin Howell",
            "username": "Antonette",
            "email": "Shanna@melissa.tv",
            "address": {
              "street": "Victor Plains",
              "suite": "Suite 879",
              "city": "Wisokyburgh",
              "zipcode": "90566-7771",
              "geo": {
                "lat": "-43.9509",
                "lng": "-34.4618"
              }
            },
            "phone": "010-692-6593 x09125",
            "website": "anastasia.net",
            "company": {
              "name": "Deckow-Crist",
              "catchPhrase": "Proactive didactic contingency",
              "bs": "synergize scalable supply-chains"
            }
          }
        """
        if let jsonData = mockUserData.data(using: .utf8) {
            let decoder = JSONDecoder()
            do {
                let user = try decoder.decode(User.self, from: jsonData)
                XCTAssertNotNil(user)
            } catch {
                XCTAssertNil(error)
            }
        }
    }
    
    func testBadUserRealmCodable() throws {
        let mockUserBadData = """
        {
            "id": 2,
            "nume": "Ervin Howell",
            "usernime": "Antonette",
            "email": "Shanna@melissa.tv",
            "address": {
              "street": "Victor Plains",
              "suite": "Suite 879",
              "city": "Wisokyburgh",
              "zipcode": "90566-7771",
              "geo": {
                "lat": "-43.9509",
                "lng": "-34.4618"
              }
            },
            "phone": "010-692-6593 x09125",
            "website": "anastasia.net",
            "company": {
              "neme": "Deckow-Crist",
              "catchPhrase": "Proactive didactic contingency",
              "bs": "synergize scalable supply-chains"
            }
          }
        """
        if let jsonData = mockUserBadData.data(using: .utf8) {
            let decoder = JSONDecoder()
            do {
                let user = try decoder.decode(User.self, from: jsonData)
                XCTAssertNil(user)
            } catch {
                XCTAssertNotNil(error)
            }
        }
    }
    
    func testSavingRealmCodable() throws {
        let post = Post()
        post.id = 1
        post.userId = 1
        post.title = "Post-It"
        post.body = "Are useful for reminders."
       
        database.realm.writeAsync {
            self.database.realm.add(post, update: .all)
        } onComplete: { error in
            XCTAssertNil(error)
        }
    }
    
    func testSavingRealmCodables() {
        var comments: [Comment] = []
        let starWarsCharacters = [
            "Luke Skywalker",
            "Darth Vader",
            "Princess Leia",
            "Han Solo",
            "Chewbacca",
            "Yoda",
            "R2-D2",
            "C-3PO",
            "Boba Fett",
            "Obi-Wan Kenobi",
            "Anakin Skywalker",
            "Padmé Amidala"]
        
        for index in 1...starWarsCharacters.count {
            let comment = Comment()
            comment.id = index
            comment.postId = Int.random(in: 1...100)
            comment.name = starWarsCharacters.randomElement() ?? "Unknown"
            comment.email = "\(starWarsCharacters.randomElement() ?? "Unknown")@star.wars"
            comment.body = "This comment is about \(starWarsCharacters.randomElement() ?? ""))"
            comments.append(comment)
        }
        
        database.realm.writeAsync {
            self.database.realm.add(comments, update: .all)
        } onComplete: { error in
            XCTAssertNil(error)
        }
    }
}
