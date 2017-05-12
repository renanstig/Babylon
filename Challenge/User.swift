//
//  User.swift
//  Challenge
//
//  Created by Renan on 11/05/17.
//  Copyright © 2017 babylonChallenge. All rights reserved.
//

import Foundation
import MapKit

struct User {
    
    public let id: Int
    public let userName: String
    public let email: String
    public let address: Address
    public let phone: String
    public let webSite: String
    public let company: Company
    
    init() {
        self.id = 0
        self.userName = ""
        self.email = ""
        self.address = Address()
        self.phone = ""
        self.webSite = ""
        self.company = Company()
    }
}

extension User {
    
    init?(json: [String: Any]) throws {
        
        guard let id = json["id"] as? Int else {
            throw SerializationError.missing("id")
        }
        
        guard let username = json["username"] as? String else {
            throw SerializationError.missing("username")
        }
        
        guard let email = json["email"] as? String else {
            throw SerializationError.missing("email")
        }
        
        guard let address = json["address"] as? [String: Any] else {
            throw SerializationError.missing("address")
        }
        
        guard let phone = json["phone"] as? String else {
            throw SerializationError.missing("phone")
        }
        
        guard let webSite = json["website"] as? String else {
            throw SerializationError.missing("webSite")
        }
        
        guard let company = json["company"] as? [String: Any] else {
            throw SerializationError.missing("company")
        }
        
        self.id = id
        self.userName = username
        self.email = email
        self.address = try! Address(json: address)!
        self.phone = phone
        self.webSite = webSite
        self.company = try! Company(json: company)!
    }
}

extension User {
    
    func getUserInfoFromServer(userId: Int, completion: @escaping (_ user: User?, _ error: Error?) -> ()) {
        var user = User()
        DataManager.sharedInstance.requestToServer(url: "http://jsonplaceholder.typicode.com/users", parameter: ["id": userId]) { (rawValue, error) in
            
            guard let raw = rawValue  else {
                completion(nil, error)
                return
            }
            do {
                user = try User(json: raw.first!)!
                completion(user, nil)
            } catch let missing as SerializationError {
                completion(nil, missing)
            } catch let error as NSError {
                completion(nil, error)
            }
        }
    }
}

struct Address {
    public let street: String
    public let suite: String
    public let city: String
    public let zipCode: String
    public let geo: CLLocationCoordinate2D
    
    init() {
        self.street = ""
        self.suite = ""
        self.city = ""
        self.zipCode = ""
        self.geo = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    }
    
}

extension Address {
    
    init?(json: [String: Any]) throws {
        
        guard let street = json["street"] as? String else {
            throw SerializationError.missing("street")
        }
        
        guard let suite = json["suite"] as? String else {
            throw SerializationError.missing("suite")
        }
        
        guard let city = json["city"] as? String else {
            throw SerializationError.missing("city")
        }
        
        guard let zipCode = json["zipcode"] as? String else {
            throw SerializationError.missing("zipcode")
        }
        
        guard let geo = json["geo"] as? [String: String],
            let lat = Double(geo["lat"]!),
            let lng = Double(geo["lng"]!) else {
            throw SerializationError.missing("geo")
        }
        
        let coordinates = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        
        if !coordinates.isValid() {
            throw SerializationError.invalid("geo", coordinates)
        }
        
        self.street = street
        self.suite = suite
        self.city = city
        self.zipCode = zipCode
        self.geo = coordinates
        
        
    }
}

struct Company {
    
    public let name: String
    public let catchPhrase: String
    public let bs: String
    
    init() {
        self.name = ""
        self.catchPhrase = ""
        self.bs = ""
    }
}

extension Company {
    
    init?(json: [String: Any]) throws {
        
        guard let name = json["name"] as? String else {
            throw SerializationError.missing("company name")
        }
        
        guard let catchPhrase = json["catchPhrase"] as? String else {
            throw SerializationError.missing("catchPhrase")
        }
        
        guard let bs = json["bs"] as? String else {
            throw SerializationError.missing("bs")
        }
        
        self.name = name
        self.catchPhrase = catchPhrase
        self.bs = bs
        
    }
}
