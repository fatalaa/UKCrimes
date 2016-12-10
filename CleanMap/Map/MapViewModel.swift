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
    mutating func fetchCrimesAtLocation(_ coordinate: CLLocationCoordinate2D)
}

struct MapViewModel: MapViewModelInterface, MapSearchResultsDelegate {
    
    fileprivate let disposeBag = DisposeBag()
    
    var view: MapViewInterface!
    
    var selectedMapItem = Variable<MKMapItem>(MKMapItem())
    
    fileprivate var dataMapper: CrimeDataMapper?
    
    fileprivate lazy var apiService: PoliceAPIClientInterface = {
        let client = PoliceAPIClient(baseURL: "https://data.police.uk/api/")
        return client
    }()
    
    fileprivate var crimes = Variable<[CrimeAnnotationModel]>([])
    
    fileprivate(set) var crimeCategories = Variable<[String:String]>([:])
    
    init(view: MapViewInterface) {
        self.view = view
        setupBindings()
        fetchCrimeCategories()
    }
    
    fileprivate mutating func fetchCrimeCategories() {
        self.view.showsNetworkActivityIndicator.value = true
        var copy = self
        apiService.fetchCrimeCategories({ (categories) in
            copy.view.showsNetworkActivityIndicator.value = false
            guard let categories = categories else {
                return
            }
            for category in categories {
                if let categoryID = category.ID, let categoryName = category.name {
                    copy.crimeCategories.value[categoryID] = categoryName
                }
            }
        },
        { (error) in
            copy.view.showsNetworkActivityIndicator.value = false
            print(error ?? "Error in fetchCrimeCategories callback")
        })
        self = copy
    }
    
    func mapSearchResultsController(_ mapSearchResultsController: MapSearchResultsController,
                                    didSelectMapItem: MKMapItem) {
        selectedMapItem.value = didSelectMapItem
    }
    
    mutating func fetchCrimesAtLocation(_ coordinate: CLLocationCoordinate2D) {
        self.view.showsNetworkActivityIndicator.value = true
        var copy = self
        apiService.fetchStreetCrimes(
            coordinate.latitude,
            longitude: coordinate.longitude,
            successBlock: { (crimes) in
                func setCrimes() {
                    guard let crimes = copy.dataMapper?.map(crimes) else {
                        return
                    }
                    copy.crimes.value = crimes
                }
                copy.view.showsNetworkActivityIndicator.value = false
                guard copy.dataMapper != nil else {
                    copy.dataMapper = CrimeDataMapper(categoryMappings: copy.crimeCategories.value)
                    setCrimes()
                    return
                }
                setCrimes()
            },
            failureBlock: { (error) in
                copy.view.showsNetworkActivityIndicator.value = false
            }
        )
        self = copy
    }
    
    fileprivate func setupBindings() {
        selectedMapItem
            .asObservable()
            .subscribe({ (mapItem) in
                guard let mapItem = mapItem.element else {
                    return
                }
                if mapItem.placemark.title == nil {
                    return
                }
                if let v = self.view {
                    v.mapItem.value = mapItem
                }
            })
            .addDisposableTo(disposeBag)
        self.crimes
            .asObservable()
            .subscribe(onNext: { (crimes) in
                self.view.crimes.value = crimes
            })
            .addDisposableTo(disposeBag)
        
    }
}
