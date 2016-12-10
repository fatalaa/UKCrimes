//
//  LocationResponseModel.swift
//  CleanMap
//
//  Created by Tibor Molnár on 05/09/16.
//  Copyright © 2016 Black Swan Data Ltd. All rights reserved.
//

import Foundation
import ObjectMapper

struct LocationResponseModel: Mappable {
    
    fileprivate enum LocationModelKeys {
        static let latitudeKey = "latitude"
        static let longitudeKey = "longitude"
        static let streetKey = "street"
    }
    
    var latitude: String?
    var longitude: String?
    var street: StreetResponseModel?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        latitude <- map[LocationModelKeys.latitudeKey]
        longitude <- map[LocationModelKeys.longitudeKey]
        street <- map[LocationModelKeys.streetKey]
    }
}
