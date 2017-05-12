//
//  Comments.swift
//  Challenge
//
//  Created by Renan on 11/05/17.
//  Copyright © 2017 babylonChallenge. All rights reserved.
//

import Foundation

struct Comments {
    
    
    public let postId: Int
    public let id: Int
    public let name: String
    public let email: String
    public let body: String
    
    init() {
        postId = 0
        id = 0
        name = ""
        email = ""
        body = ""
    }
    
    public init?(json: [String: Any]) throws {
        
        guard let postId = json["postId"] as? Int else {
            throw SerializationError.missing("postId")
        }
        
        guard let id = json["id"] as? Int else {
            throw SerializationError.missing("id")
        }
        
        guard let name = json["name"] as? String else {
            throw SerializationError.missing("name")
        }
        
        guard let email = json["email"] as? String else {
            throw SerializationError.missing("email")
        }
        
        guard let body = json["body"] as? String  else {
            throw SerializationError.missing("body")
        }
        
        self.postId = postId
        self.id = id
        self.name = name
        self.email = email
        self.body = body
    }
}

extension Comments {
    func getCommentsFromServer(postId: Int, completion: @escaping (_ comments: [Comments]?, _ error: Error?) -> ()) {
        var comments: [Comments] = []
        DataManager.sharedInstance.requestToServer(url: "http://jsonplaceholder.typicode.com/comments", parameter: ["postId": postId]) { (rawList, error) in
            
            guard let raw = rawList else {
                completion(nil, error)
                return
            }
            defer {
                completion(comments, nil)
            }
            for l in raw {
                do {
                    comments.append(try Comments(json: l)!)
                } catch let missing as SerializationError {
                    completion(nil, missing)
                } catch let error as NSError {
                    completion(nil, error)
                }
            }
        }
    }
    
}
