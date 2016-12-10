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
    func fetchStreetCrimes(_ latitude: Double, longitude: Double, successBlock: @escaping ([CrimeResponseModel]?) -> (), failureBlock: @escaping (NSError?) -> ())
    func fetchCrimeCategories(_ successBlock: @escaping ([CrimeCategoryResponseModel]?) -> (), _ failureBlock: @escaping (NSError?) -> ())
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
    
    func fetchStreetCrimes(_ latitude: Double, longitude: Double, successBlock: @escaping ([CrimeResponseModel]?) -> (), failureBlock: @escaping (NSError?) -> ()) {
        guard let baseURL = baseURL else {
            return
        }
        let URL = baseURL + PoliceAPIClientConstants.streetCrimesEndpointKey
        let parameters = [
            PoliceAPIClientConstants.latitudeKey: String(latitude),
            PoliceAPIClientConstants.longitudeKey: String(longitude)
        ]
        Alamofire.request(URL, method: .get, parameters: parameters)
            .responseArray { (response: DataResponse<[CrimeResponseModel]>) in
                guard let result = response.result.value else {
                    failureBlock(response.result.error as NSError?)
                    return
                }
                successBlock(result)
        }
    }
    
    func fetchCrimeCategories(_ successBlock: @escaping ([CrimeCategoryResponseModel]?) -> (),
                              _ failureBlock: @escaping (NSError?) -> ()) {
        guard let baseURL = baseURL else {
            return
        }
        let URL = baseURL + PoliceAPIClientConstants.crimeCategoriesEndpointKey
        Alamofire.request(URL)
            .responseArray { (response: DataResponse<[CrimeCategoryResponseModel]>) in
                guard let result = response.result.value else {
                    failureBlock(response.result.error as NSError?)
                    return
                }
                successBlock(result)
            }
    }
}
