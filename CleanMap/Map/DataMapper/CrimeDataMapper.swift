//
//  CrimeDataMapper.swift
//  CleanMap
//
//  Created by Tibor Molnár on 07/09/16.
//  Copyright © 2016 Black Swan Data Ltd. All rights reserved.
//

import Foundation
import MapKit

protocol CrimeDataMapperInterface {
    func map(_ crimes: [CrimeResponseModel]?) -> [CrimeAnnotationModel]?
    func map(_ crime: CrimeResponseModel?) -> CrimeAnnotationModel?
}

struct CrimeDataMapper: CrimeDataMapperInterface {
    
    init(categoryMappings: [String:String]!) {
        self.categoryMappings = categoryMappings
    }
    
    var categoryMappings: [String:String]!
    
    func map(_ crime: CrimeResponseModel?) -> CrimeAnnotationModel? {
        guard let category = crime?.category,
                  let ID = crime?.ID,
            let coordinate = CLLocationCoordinate2D.create(crime),
            let date = crime?.month else {
                return nil
        }
        if let mappedCategory = categoryMappings[category] {
            return CrimeAnnotationModel(coordinate: coordinate,
                                        category: mappedCategory,
                                        persistentID: String(ID),
                                            date: date
            )
        }
        return nil
    }
    
    func map(_ crimes: [CrimeResponseModel]?) -> [CrimeAnnotationModel]? {
        var annotationModels = [CrimeAnnotationModel]()
        guard let crimes = crimes else {
            return nil
        }
        for crime in crimes {
            guard let annotationModel = map(crime) else {
                continue
            }
            annotationModels.append(annotationModel)
        }
        return annotationModels
    }
}
