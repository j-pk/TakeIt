//
//  TakeItTests.swift
//  TakeItTests
//
//  Created by Parker on 7/10/23.
//

import XCTest
@testable import TakeIt

final class TakeItTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
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
}
