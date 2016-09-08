//
//  PoliceAPIClient.swift
//  CleanMap
//
//  Created by Tibor Molnár on 05/09/16.
//  Copyright © 2016 Black Swan Data Ltd. All rights reserved.
//

import Alamofire
import AlamofireObjectMapper
import Foundation

protocol PoliceAPIClientInterface {
    var baseURL: String? {get set}
    func fetchStreetCrimes(latitude: Double, longitude: Double, successBlock: ([CrimeResponseModel]?) -> (), failureBlock: (NSError?) -> ())
    func fetchCrimeCategories(successBlock: ([CrimeCategoryResponseModel]?) -> (), failureBlock: (NSError?) -> ())
}

struct PoliceAPIClient: PoliceAPIClientInterface {
    
    enum PoliceAPIClientConstants {
        static let crimeCategoriesEndpointKey = "crime-categories"
        static let streetCrimesEndpointKey = "crimes-street/all-crime"
        static let latitudeKey = "lat"
        static let longitudeKey = "lng"
    }
    
    init(baseURL: String) {
        self.baseURL = baseURL
    }
    
    var baseURL: String?
    
    func fetchStreetCrimes(latitude: Double, longitude: Double, successBlock: ([CrimeResponseModel]?) -> (), failureBlock: (NSError?) -> ()) {
        guard let URL = baseURL?.stringByAppendingString(PoliceAPIClientConstants.streetCrimesEndpointKey) else {
            return
        }
        let parameters = [
            PoliceAPIClientConstants.latitudeKey: String(latitude),
            PoliceAPIClientConstants.longitudeKey: String(longitude)
        ]
        Alamofire.request(.GET,
                          URL,
                          parameters: parameters,
                          encoding: .URL,
                          headers: [:])
            .responseArray { (response: Response<[CrimeResponseModel], NSError>) in
                guard let result = response.result.value else {
                    failureBlock(response.result.error)
                    return
                }
                successBlock(result)
        }
    }
    
    func fetchCrimeCategories(successBlock: ([CrimeCategoryResponseModel]?) -> (),
                              failureBlock: (NSError?) -> ()) {
        guard let URL = baseURL?.stringByAppendingString(PoliceAPIClientConstants.crimeCategoriesEndpointKey) else {
            return
        }
        Alamofire.request(.GET,
                          URL,
                          parameters: [:],
                          encoding: .URL,
                          headers: [:])
            .responseArray { (response: Response<[CrimeCategoryResponseModel], NSError>) in
                guard let result = response.result.value else {
                    failureBlock(response.result.error)
                    return
                }
                successBlock(result)
            }
    }
}