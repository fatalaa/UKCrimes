//
//  CrimeAnnotationModel.swift
//  CleanMap
//
//  Created by Tibor Molnár on 07/09/16.
//  Copyright © 2016 Black Swan Data Ltd. All rights reserved.
//

import MapKit

struct CrimeAnnotationModel {
    
    var coordinate: CLLocationCoordinate2D
    
    var category: String?
    
    var persistentID: String?
    
    var date: String?
    
    init(coordinate: CLLocationCoordinate2D!, category: String!, persistentID: String!, date: String!) {
        self.coordinate = coordinate
        self.category = category
        self.persistentID = persistentID
        self.date = date
    }
}