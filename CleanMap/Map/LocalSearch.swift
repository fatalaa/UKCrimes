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
    func executeQuery(_ query: String,
                      successBlock: @escaping (_ response: MKLocalSearchResponse?) -> (),
                      failureBlock: @escaping (_ error: NSError?) -> ())
}

struct LocalSearch: LocalSearchInterface {
    
    func executeQuery(_ query: String,
                      successBlock: @escaping (_ response: MKLocalSearchResponse?) -> (),
                      failureBlock: @escaping (_ error: NSError?) -> ()) {
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = query
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            if let error = error {
                failureBlock(error as NSError?)
            } else {
                successBlock(response)
            }
        }
    }
}
