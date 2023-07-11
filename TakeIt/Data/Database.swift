//
//  Database.swift
//  TakeIt
//
//  Created by Parker on 7/10/23.
//

import Combine
import Foundation
import RealmSwift

public enum DatabaseError: Error, LocalizedError {
    case initFailure(Error)
  
    public var errorDescription: String? {
        switch self {
        case .initFailure(let error): return "Realm failed to initialize: \(error)"
        }
    }
}

class Database {
    var realm: Realm
    
    init() {
        do {
            self.realm = try Realm()
        } catch {
            fatalError(DatabaseError.initFailure(error).localizedDescription)
        }
    }
}
