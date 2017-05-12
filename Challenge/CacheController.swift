//
//  CacheController.swift
//  Challenge
//
//  Created by Renan on 10/05/17.
//  Copyright © 2017 babylonChallenge. All rights reserved.
//

import Foundation
import UIKit
import CoreData

var requestCount = 0

class CacheController: URLProtocol {
    
    var connection: NSURLConnection!
    var mutableData: NSMutableData!
    var response: URLResponse!
    
    override class func canInit(with request: URLRequest) -> Bool {
        if URLProtocol.property(forKey: "BabylonHandler", in: request) != nil {
            return false
        } else {
            return true
        }
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        
        if (!isConnectedToNetwork()) {
            let possibleCachedResponse = self.cachedResponseForCurrentRequest()
            if let cachedResponse = possibleCachedResponse {
                let data = cachedResponse.value(forKey: "data") as! Foundation.Data!
                let mimeType = cachedResponse.value(forKey: "mimeType") as! String!
                let encoding = cachedResponse.value(forKey: "encoding") as! String!
                
                let response = URLResponse(url: self.request.url!, mimeType: mimeType, expectedContentLength: data!.count, textEncodingName: encoding)
                
                self.client!.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
                self.client!.urlProtocol(self, didLoad: data!)
                self.client!.urlProtocolDidFinishLoading(self)
                
            }
        } else {            
            let newRequest = self.request as! NSMutableURLRequest
            URLProtocol.setProperty(true, forKey: "BabylonHandler", in: newRequest)
            self.connection = NSURLConnection(request: newRequest as URLRequest, delegate: self)
        }
        
    }
    
    override func stopLoading() {
        if self.connection != nil {
            self.connection.cancel()
        }
        self.connection = nil
    }
    
    
    func connection(_ connection: NSURLConnection!, didReceiveResponse response: URLResponse!) {
        self.client!.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        self.response = response
        self.mutableData = NSMutableData()
    }
    
    func connection(_ connection: NSURLConnection!, didReceiveData data: Foundation.Data!) {
        self.client!.urlProtocol(self, didLoad: data)
        self.mutableData.append(data)
    }
    
    func connectionDidFinishLoading(_ connection: NSURLConnection!) {
        self.client!.urlProtocolDidFinishLoading(self)
        self.saveCachedResponse()
    }
    
    func connection(_ connection: NSURLConnection!, didFailWithError error: NSError!) {
        self.client!.urlProtocol(self, didFailWithError: error)
    }
    
    func saveCachedResponse () {
        //println("Saving cached response")
        
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.managedObjectContext
        
        let cachedResponse = NSEntityDescription.insertNewObject(forEntityName: "CachedURLResponse", into: context)
        
        cachedResponse.setValue(self.mutableData, forKey: "data")
        cachedResponse.setValue(self.request.url!.absoluteString, forKey: "url")
        cachedResponse.setValue(Date(), forKey: "timestamp")
        cachedResponse.setValue(self.response.mimeType, forKey: "mimeType")
        cachedResponse.setValue(self.response.textEncodingName, forKey: "encoding")
        
        let success: Bool
        do {
            try context.save()
            success = true
        } catch let error as NSError {
            print(error.description)
            success = false
        }
        if !success {
            print("Could not cache the response")
        }
    }
    
    func cachedResponseForCurrentRequest() -> NSManagedObject? {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        let entity = NSEntityDescription.entity(forEntityName: "CachedURLResponse", in: context)
        
        fetchRequest.entity = entity
        
        let predicate = NSPredicate(format:"url == %@", self.request.url!.absoluteString)
        fetchRequest.predicate = predicate
        
        do {
            let possibleResult = try context.fetch(fetchRequest)
            if !possibleResult.isEmpty {
                return possibleResult[0] as? NSManagedObject
            }
        } catch let error as NSError {
            print(error.description)
            return nil
        }
        return nil
    }
    
}
