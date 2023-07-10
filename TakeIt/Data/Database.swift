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
    case failedToInsertObject(String)
    case failedToDeleteObject(String)

    public var errorDescription: String? {
        switch self {
        case .initFailure(let error): return "Realm failed to initialize: \(error)"
        default:
            return ""
        }
    }
}

class Database {
    var realm: Realm
    private var subscriptions = Set<AnyCancellable>()

    init() {
        do {
            self.realm = try Realm()
        } catch {
            fatalError(DatabaseError.initFailure(error).localizedDescription)
        }
    }
    
    public func update(entity: Object, update: Bool = true) -> Future<Bool, DatabaseError> {
        return Future { promise in
            self.realm.writeAsync {
                if update {
                    self.realm.add(entity, update: .all)
                } else {
                    self.realm.add(entity)
                }
            } onComplete: { error in
                if let error = error {
                    promise(.failure(.failedToInsertObject(error.localizedDescription)))
                } else {
                    promise(.success(true))
                }
            }
        }
    }
    
    public func remove<T>(entity: T.Type) -> Future<Bool, DatabaseError> where T: Object {
        return Future { promise in
            self.realm.writeAsync {
                let entities = self.realm.objects(entity.self)
                self.realm.delete(entities)
            } onComplete: { error in
                if let error = error {
                    promise(.failure(.failedToDeleteObject(error.localizedDescription)))
                } else {
                    promise(.success(true))
                }
            }
        }
    }
    
    public func populateEntity<T>(entity: T.Type, data: Decodable, update: Bool = true) -> Future<Bool, DatabaseError> where T: Object {
        return Future { promise in
            self.realm.writeAsync {
                self.realm.create(entity.self, value: data, update: update ? .all : .error)
            } onComplete: { error in
                if let error = error {
                    promise(.failure(.failedToInsertObject(error.localizedDescription)))
                } else {
                    promise(.success(true))
                }
            }
        }
    }
    
    public func populateEntities<T>(entity: T.Type, collection: [T], update: Bool = true) -> AnyPublisher<Bool, DatabaseError> where T: Object & Decodable {
        return Future { promise in
            let populateCodableCollectionPublishers = collection.compactMap({ self.populateEntity(entity: entity, data: $0, update: update) })
            Publishers.MergeMany(populateCodableCollectionPublishers)
                .collect()
                .sink { result in
                    switch result {
                    case .failure(let error):
                        promise(.failure(error))
                    case .finished:
                        break
                    }
                } receiveValue: { objects in
                    promise(.success(objects.allSatisfy { $0 == true }))
                }.store(in: &self.subscriptions)
        }.eraseToAnyPublisher()
    }
}
