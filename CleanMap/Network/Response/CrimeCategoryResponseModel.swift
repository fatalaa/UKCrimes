//
//  CrimeCategoryResponseModel.swift
//  CleanMap
//
//  Created by Tibor Molnár on 07/09/16.
//  Copyright © 2016 Black Swan Data Ltd. All rights reserved.
//

import Foundation
import ObjectMapper

struct CrimeCategoryResponseModel: Mappable {
    
    private enum CrimeCategoryKeys {
        static let IDKey = "url"
        static let nameKey = "name"
    }
    
    var ID: String?
    var name: String?
    
    init?(_ map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        ID <- map[CrimeCategoryKeys.IDKey]
        name <- map[CrimeCategoryKeys.nameKey]
    }
}
