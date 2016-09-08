//
//  MKMapview-Extensions.swift
//  CleanMap
//
//  Created by Tibor Molnár on 06/09/16.
//  Copyright © 2016 Black Swan Data Ltd. All rights reserved.
//

import MapKit

extension MKMapView {
    func setVisibleRegion(radius: Double, centerCoordinate: CLLocationCoordinate2D) {
        
        enum MKMapViewExtensionConstants {
            static let mileAsMeters = 1609.344
        }
        
        func milesToMeters(mile: Double) -> Double {
            return mile * MKMapViewExtensionConstants.mileAsMeters
        }
        let region = MKCoordinateRegionMakeWithDistance(centerCoordinate,
                                                        milesToMeters(radius),
                                                        milesToMeters(radius))
        setRegion(region, animated: true)
    }
    
    func addAnnotationsBasedOnCrimes(crimes: [CrimeAnnotationModel]) {
        for crime in crimes {
            let annotation = MKPointAnnotation()
            annotation.coordinate = crime.coordinate
            if let category = crime.category {
                annotation.title = category
            }
            if let date = crime.date {
                annotation.subtitle = date
            }
            addAnnotation(annotation)
        }
    }
}
