//
//  DataManager.swift
//  Challenge
//
//  Created by Renan on 09/05/17.
//  Copyright © 2017 babylonChallenge. All rights reserved.
//

import Foundation

enum JSONError: String, Error {
    case NoData = "ERROR: no data"
    case ConversionFailed = "ERROR: conversion from JSON failed"
}

class DataManager {
    
    let session: URLSession?
    
    init() {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses?.insert(CacheController.self, at: 0)
        session = URLSession(configuration: configuration)
    }
    
    class var sharedInstance: DataManager {
        struct Singleton {
            static let instance = DataManager()
        }
        return Singleton.instance
    }
    
    func requestToServer(url: String, parameter: [String: Any]?, completionClosure: @escaping (_ json: [[String: Any]]?, _ error: Error?) -> ()) {
        
        var newUrl = url
        if parameter != nil {
            let parameters = parameter!.first!.key + "=\((parameter?.first?.value as! Int))"
            newUrl = url+"?"+parameters
        }
        
        let urlRequest = URLRequest(url: URL(string: newUrl)!)
        
        session!.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            do {
                guard let data = data else {
                    throw JSONError.NoData
                }
                guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] else {
                    throw JSONError.ConversionFailed
                }
                completionClosure(json, nil)
            } catch let jsonError as JSONError {
                completionClosure(nil, jsonError)
            } catch let error as NSError {
                completionClosure(nil, error)
            }
        }).resume()
    }
}




