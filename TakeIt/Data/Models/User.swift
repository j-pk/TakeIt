//
//  User.swift
//  TakeIt
//
//  Created by Parker on 7/10/23.
//

import RealmSwift

/*
 {
     "id": 1,
     "name": "Leanne Graham",
     "username": "Bret",
     "email": "Sincere@april.biz",
     "address": {
       "street": "Kulas Light",
       "suite": "Apt. 556",
       "city": "Gwenborough",
       "zipcode": "92998-3874",
       "geo": {
         "lat": "-37.3159",
         "lng": "81.1496"
       }
     },
     "phone": "1-770-736-8031 x56442",
     "website": "hildegard.org",
     "company": {
       "name": "Romaguera-Crona",
       "catchPhrase": "Multi-layered client-server neural-net",
       "bs": "harness real-time e-markets"
     }
}
*/

class User: Object, ObjectKeyIdentifiable, Decodable {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var name: String
    @Persisted var username: String
    @Persisted var email: String
    @Persisted var phone: String
    @Persisted var website: String
    @Persisted var address: Address?
    @Persisted var company: Company?
    @Persisted var posts: List<Post>
    
    // MARK: Decodable
    enum CodingKeys: String, CodingKey {
        case id, name, username, email, phone
        case website, address, company
    }
    
    required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        username = try container.decode(String.self, forKey: .username)
        email = try container.decode(String.self, forKey: .email)
        phone = try container.decode(String.self, forKey: .phone)
        website = try container.decode(String.self, forKey: .website)
        address = try container.decode(Address.self, forKey: .address)
        company = try container.decode(Company.self, forKey: .company)
    }
}

// Embedded allows cascading / auto-removal when a User object is removed
class Address: EmbeddedObject, Decodable {
    @Persisted var street: String
    @Persisted var suite: String
    @Persisted var city: String
    @Persisted var zipcode: String
    @Persisted var geo: Geo?
    
    // MARK: Decodable
    enum CodingKeys: String, CodingKey {
        case street, suite, city, email, zipcode, geo
    }
    
    required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        street = try container.decode(String.self, forKey: .street)
        suite = try container.decode(String.self, forKey: .suite)
        city = try container.decode(String.self, forKey: .city)
        zipcode = try container.decode(String.self, forKey: .zipcode)
        geo = try container.decode(Geo.self, forKey: .geo)
    }
}

class Geo: EmbeddedObject, Decodable {
    @Persisted var lat: String
    @Persisted var lng: String
    
    // MARK: Decodable
    enum CodingKeys: String, CodingKey {
        case lat, lng
    }
    
    required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        lat = try container.decode(String.self, forKey: .lat)
        lng = try container.decode(String.self, forKey: .lng)
    }
}

class Company: EmbeddedObject, Decodable {
    @Persisted var name: String
    @Persisted var catchPhrase: String
    @Persisted var bs: String
    
    // MARK: Decodable
    enum CodingKeys: String, CodingKey {
        case name, catchPhrase, bs
    }
    
    required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try container.decode(String.self, forKey: .name)
        catchPhrase = try container.decode(String.self, forKey: .catchPhrase)
        bs = try container.decode(String.self, forKey: .bs)
    }
}

extension User {
    static var sampleUser: User = {
        let user = User()
        user.id = 1
        user.name = "Billy Bob"
        user.username = "BillyBobUsername"
        user.email = "BillyBobUsername@billysells.com"
        user.phone = "6782156845"
        user.website = "www.billysells.com"
        
        let address = Address()
        address.street = "Elm Street"
        address.suite = "Elm Suite"
        address.city = "Elm City"
        address.zipcode = "123"
        
        let geo = Geo()
        geo.lat = "1110.0"
        geo.lng = "1001.1"
        
        address.geo = geo
        user.address = address
        
        let company = Company()
        company.name = "Billy Sells Company"
        company.catchPhrase = "Billy Sells Like Hell"
        company.bs = "BS"
        
        user.company = company
        
        for indexValue in 1...10 {
            let post = Post()
            post.id = indexValue
            post.userId = indexValue
            post.title = "Post-It Send-It \(indexValue)"
            post.body = "Post Body, Send Body \(indexValue)"
            
            let comment = Comment()
            comment.postId = indexValue
            comment.id = indexValue
            comment.name = "Comment name"
            comment.email = "this.is.a.comment@comments.com"
            comment.body = "This is a comment."
            post.comments.append(comment)

            user.posts.append(post)
        }
        
        return user
    }()
}
