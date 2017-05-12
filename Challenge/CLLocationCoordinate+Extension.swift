//
//  CLLocationCoordinate+Extensions.swift
//  Challenge
//
//  Created by Renan on 11/05/17.
//  Copyright © 2017 babylonChallenge. All rights reserved.
//

import Foundation
import MapKit

extension CLLocationCoordinate2D {
    func isValid() -> Bool {
        //A Location is invalid when its latitude is greater than 90 degrees or less than -90 degrees. Its longitude is greater than 180 degrees or less than -180 degrees.
        
        guard case (-90...90, -180...180) = (self.latitude, self.longitude) else {
            return false
        }
        return true
    }
}
