//
//  MapViewModel.swift
//  CleanMap
//
//  Created by Tibor Molnár on 05/09/16.
//  Copyright © 2016 Black Swan Data Ltd. All rights reserved.
//

import Foundation
import RxSwift
import MapKit

protocol MapViewModelInterface {
    var view: MapViewInterface! {get set}
    var selectedMapItem: Variable<MKMapItem> {get set}
    mutating func fetchCrimesAtLocation(coordinate: CLLocationCoordinate2D)
}

struct MapViewModel: MapViewModelInterface, MapSearchResultsDelegate {
    
    private let disposeBag = DisposeBag()
    
    var view: MapViewInterface!
    
    var selectedMapItem = Variable<MKMapItem>(MKMapItem())
    
    private var dataMapper: CrimeDataMapper?
    
    private lazy var apiService: PoliceAPIClientInterface = {
        let client = PoliceAPIClient(baseURL: "https://data.police.uk/api/")
        return client
    }()
    
    private var crimes = Variable<[CrimeAnnotationModel]>([])
    
    private(set) var crimeCategories = Variable<[String:String]>([:])
    
    init(view: MapViewInterface) {
        self.view = view
        setupBindings()
        fetchCrimeCategories()
    }
    
    private mutating func fetchCrimeCategories() {
        self.view.showsNetworkActivityIndicator.value = true
        apiService.fetchCrimeCategories({ (categories) in
            self.view.showsNetworkActivityIndicator.value = false
            guard let categories = categories else {
                return
            }
            for category in categories {
                if let categoryID = category.ID, categoryName = category.name {
                    self.crimeCategories.value[categoryID] = categoryName
                }
            }
        },
        failureBlock: { (error) in
            self.view.showsNetworkActivityIndicator.value = false
            print(error)
        })
    }
    
    func mapSearchResultsController(mapSearchResultsController: MapSearchResultsController,
                                    didSelectMapItem: MKMapItem) {
        selectedMapItem.value = didSelectMapItem
    }
    
    mutating func fetchCrimesAtLocation(coordinate: CLLocationCoordinate2D) {
        self.view.showsNetworkActivityIndicator.value = true
        apiService.fetchStreetCrimes(
            coordinate.latitude,
            longitude: coordinate.longitude,
            successBlock: { (crimes) in
                func setCrimes() {
                    guard let crimes = self.dataMapper?.map(crimes) else {
                        return
                    }
                    self.crimes.value = crimes
                }
                self.view.showsNetworkActivityIndicator.value = false
                guard self.dataMapper != nil else {
                    self.dataMapper = CrimeDataMapper(categoryMappings: self.crimeCategories.value)
                    setCrimes()
                    return
                }
                setCrimes()
            },
            failureBlock: { (error) in
                self.view.showsNetworkActivityIndicator.value = false
            }
        )
    }
    
    private func setupBindings() {
        selectedMapItem
            .asObservable()
            .subscribeNext { (mapItem) in
                if mapItem.placemark.title == nil {
                    return
                }
                if let v = self.view {
                    v.mapItem.value = mapItem
                }
            }
            .addDisposableTo(disposeBag)
        crimes
            .asObservable()
            .subscribeNext { (crimes) in
                self.view.crimes.value = crimes
            }
            .addDisposableTo(disposeBag)
        
    }
}