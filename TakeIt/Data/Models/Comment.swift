//
//  Comment.swift
//  TakeIt
//
//  Created by Parker on 7/10/23.
//

import RealmSwift
/*
 {
     "postId": 1,
     "id": 1,
     "name": "id labore ex et quam laborum",
     "email": "Eliseo@gardner.biz",
     "body": "laudantium enim quasi est quidem magnam voluptate ipsam eos\ntempora quo necessitatibus\ndolor quam autem quasi\nreiciendis et nam sapiente accusantium"
}
 */

class Comment: Object, ObjectKeyIdentifiable, Decodable {
    @Persisted var postId: Int
    @Persisted(primaryKey: true) var id: Int
    @Persisted var name: String
    @Persisted var email: String
    @Persisted var body: String
    
    // MARK: Decodable
    enum CodingKeys: String, CodingKey {
        case postId, id, name, email, body
    }
    
    required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        postId = try container.decode(Int.self, forKey: .postId)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        email = try container.decode(String.self, forKey: .email)
        body = try container.decode(String.self, forKey: .body)
    }
}

extension Comment {
    static var sampleComment: Comment = {
        let comment = Comment()
        comment.postId = 1
        comment.id = 1
        comment.name = "Comment name"
        comment.email = "this.is.a.comment@comments.com"
        comment.body = "This is a comment."
        return comment
    }()
}

