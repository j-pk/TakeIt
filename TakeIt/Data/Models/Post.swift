//
//  Post.swift
//  TakeIt
//
//  Created by Parker on 7/10/23.
//

import RealmSwift

/*
 {
     "userId": 1,
     "id": 1,
     "title": "sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
     "body": "quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto"
 }
 */

class Post: Object, ObjectKeyIdentifiable, Decodable {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var userId: Int
    @Persisted var title: String
    @Persisted var body: String
    @Persisted var comments: List<Comment>
    @Persisted var user: User?
    
    // MARK: Decodable
    enum CodingKeys: String, CodingKey {
        case id, userId
        case title, body
    }
    
    required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        userId = try container.decode(Int.self, forKey: .userId)
        title = try container.decode(String.self, forKey: .title)
        body = try container.decode(String.self, forKey: .body)
    }
}

extension Post {
    static var samplePost: Post = {
        let post = Post()
        post.id = 1
        post.userId = 1
        post.title = "Post-It Send-It"
        post.body = "Post Body, Send Body"
        
        for indexValue in 1...5 {
            let comment = Comment()
            comment.postId = indexValue
            comment.id = indexValue
            comment.name = "Comment \(indexValue)"
            comment.email = "this.is.a.comment\(indexValue)@comments.com"
            comment.body = "This is a comment."
    
            post.comments.append(comment)
        }
        
        return post
    }()

}
