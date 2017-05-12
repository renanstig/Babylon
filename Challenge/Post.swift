//
//  List.swift
//  Challenge
//
//  Created by Renan on 09/05/17.
//  Copyright © 2017 babylonChallenge. All rights reserved.
//

import Foundation


enum SerializationError: Error {
    case missing(String)
    case invalid(String, Any)
}

struct Post {
    
    
    public let userId: Int
    public let id: Int
    public let title: String
    public let body: String
    
    init() {
        userId = 0
        id = 0
        title = ""
        body = ""
    }
    
    public init?(json: [String: Any]) throws {
        
        guard let userId = json["userId"] as? Int else {
            throw SerializationError.missing("userId")
        }
        
        guard let id = json["id"] as? Int else {
            throw SerializationError.missing("id")
        }
        
        guard let title = json["title"] as? String else {
            throw SerializationError.missing("title")
        }
        
        guard let body = json["body"] as? String  else {
            throw SerializationError.missing("body")
        }
        
        self.userId = userId
        self.id = id
        self.title = title
        self.body = body
    }
}

extension Post {
    
    func getPostsFromServer(completion: @escaping (_ posts: [Post]?, _ error: Error?) -> ()) {
        var posts: [Post] = []
        DataManager.sharedInstance.requestToServer(url: "http://jsonplaceholder.typicode.com/posts", parameter: nil) { (rawList, error) in
            
            guard let raw = rawList else {
                completion(nil, error)
                return
            }
            defer {
                completion(posts, nil)
            }
            for l in raw {
                do {
                    posts.append(try Post(json: l)!)
                } catch let missing as SerializationError {
                    completion(nil, missing)
                    break
                } catch let error as NSError {
                    completion(nil, error)
                    break
                }
            }
        }
    }
}
