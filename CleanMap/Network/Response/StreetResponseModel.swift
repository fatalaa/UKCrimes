//
//  StreetResponseModel.swift
//  CleanMap
//
//  Created by Tibor Molnár on 05/09/16.
//  Copyright © 2016 Black Swan Data Ltd. All rights reserved.
//

import Foundation
import ObjectMapper

struct StreetResponseModel: Mappable {
    
    fileprivate enum StreetModelKeyNames {
        static let IDKey = "id"
        static let nameKey = "name"
    }
    
    var ID: Int?
    var name: String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        ID <- map[StreetModelKeyNames.IDKey]
        name <- map[StreetModelKeyNames.nameKey]
    }
}
