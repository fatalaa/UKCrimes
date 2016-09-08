//
//  LocalSearch.swift
//  CleanMap
//
//  Created by Tibor Molnár on 06/09/16.
//  Copyright © 2016 Black Swan Data Ltd. All rights reserved.
//

import Foundation
import MapKit
import RxSwift

protocol LocalSearchInterface {
    func executeQuery(query: String,
                      successBlock: (response: MKLocalSearchResponse?) -> (),
                      failureBlock: (error: NSError?) -> ())
}

struct LocalSearch: LocalSearchInterface {
    
    func executeQuery(query: String,
                      successBlock: (response: MKLocalSearchResponse?) -> (),
                      failureBlock: (error: NSError?) -> ()) {
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = query
        let search = MKLocalSearch(request: request)
        search.startWithCompletionHandler { (response, error) in
            if let error = error {
                failureBlock(error: error)
            } else {
                successBlock(response: response)
            }
        }
    }
}
