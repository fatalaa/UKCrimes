//
//  CLLocationCoordinate2D-Extensions.swift
//  CleanMap
//
//  Created by Tibor Molnár on 07/09/16.
//  Copyright © 2016 Black Swan Data Ltd. All rights reserved.
//

import MapKit

extension CLLocationCoordinate2D {
    
    static func create(crime: CrimeResponseModel?) -> CLLocationCoordinate2D? {
        guard let lat = crime?.location?.latitude, lon = crime?.location?.longitude else {
            return nil
        }
        if let latDouble = Double(lat), lonDouble = Double(lon) {
            return CLLocationCoordinate2DMake(latDouble, lonDouble)
        } else {
            return nil
        }
    }
}
