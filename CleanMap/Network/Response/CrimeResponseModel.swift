//
//  CrimeResponseModel.swift
//  CleanMap
//
//  Created by Tibor Molnár on 05/09/16.
//  Copyright © 2016 Black Swan Data Ltd. All rights reserved.
//

import Foundation
import ObjectMapper

struct CrimeResponseModel: Mappable {
    
    fileprivate enum CrimeModelKeys {
        static let categoryKey = "category"
        static let persistentIDKey = "persistent_id"
        static let locationTypeKey = "location_type"
        static let locationSubTypeKey = "location_subtype"
        static let IDKey = "id"
        static let locationKey = "location"
        static let contextKey = "context"
        static let monthKey = "month"
        static let outcomeStatusKey = "outcome_status"
    }
    
    var category: String?
    var persistentID: String?
    var locationType: String?
    var locationSubtype: String?
    var ID: Int?
    var location: LocationResponseModel?
    var context: String?
    var month: String?
    var outcomeStatus: String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        category <- map[CrimeModelKeys.categoryKey]
        persistentID <- map[CrimeModelKeys.persistentIDKey]
        locationType <- map[CrimeModelKeys.locationKey]
        locationSubtype <- map[CrimeModelKeys.locationSubTypeKey]
        ID <- map[CrimeModelKeys.IDKey]
        location <- map[CrimeModelKeys.locationKey]
        context <- map[CrimeModelKeys.contextKey]
        month <- map[CrimeModelKeys.monthKey]
        outcomeStatus <- map[CrimeModelKeys.outcomeStatusKey]
    }
}
