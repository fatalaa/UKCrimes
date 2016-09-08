//
// Created by Tibor Molnár on 01/09/16.
// Copyright (c) 2016 Black Swan Data Ltd. All rights reserved.
//

import MapKit
import RxCocoa
import RxSwift
import UIKit

protocol MapViewInterface {
    var viewModel: MapViewModelInterface! {get set}
    var mapItem: Variable<MKMapItem> {get set}
    var showsNetworkActivityIndicator: Variable<Bool> {get set}
    var crimes: Variable<[CrimeAnnotationModel]> {get set}
}

class MapViewController: UIViewController, MKMapViewDelegate, MapViewInterface {
    
    private enum MapViewControllerContants {
        static let mapRadiusWhenPlaceSelected = 5.0
    }
    
    private var searchController: UISearchController!
    
    private var mapView: MKMapView!
    
    var mapItem = Variable<MKMapItem>(MKMapItem())
    
    var showsNetworkActivityIndicator = Variable<Bool>(false)
    
    var crimes = Variable<[CrimeAnnotationModel]>([])
    
    private let disposeBag = DisposeBag()
    
    var viewModel: MapViewModelInterface!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView = MKMapView(frame: view.frame)
        view.addSubview(mapView)
        mapView.delegate = self
        mapView.region.center = CLLocationCoordinate2DMake(51.5073509, -0.1277583)
        viewModel = MapViewModel(view: self)
        
        if let viewModel = viewModel as? MapSearchResultsDelegate {
            let searchResultsController = MapSearchResultsController(style: .Plain,
                                                                     delegate: viewModel)
            searchController = UISearchController(searchResultsController: searchResultsController)
            searchController.hidesNavigationBarDuringPresentation = false
            searchController.dimsBackgroundDuringPresentation = true
            searchController.searchResultsUpdater = searchResultsController
            navigationItem.titleView = searchController.searchBar
            definesPresentationContext = true
        }
        
        setupBindings()
    }
    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        let region = MKCoordinateRegionMake(userLocation.coordinate, MKCoordinateSpanMake(1, 1))
        mapView.setRegion(mapView.regionThatFits(region), animated: true)
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier("RK") as? MKPinAnnotationView
        if annotationView != nil {
            annotationView?.annotation = annotation
        } else {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "RK")
            annotationView?.canShowCallout = true
            annotationView?.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        }
        return annotationView
    }
    
    func setupBindings() {
        mapItem
            .asObservable()
            .subscribeNext({ [weak self] (mapItem) in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.searchController.dismissViewControllerAnimated(true, completion: { [weak self] in
                    guard let innerStrongSelf = self, coordinate = mapItem.placemark.location?.coordinate else {
                        return
                    }
                    innerStrongSelf.mapView.setVisibleRegion(
                        MapViewControllerContants.mapRadiusWhenPlaceSelected,
                        centerCoordinate: coordinate
                    )
                    innerStrongSelf.viewModel.fetchCrimesAtLocation(coordinate)
                })
                
            })
            .addDisposableTo(disposeBag)
        
        showsNetworkActivityIndicator
            .asObservable()
            .subscribeNext { (showsNetworkActivityIndicator) in
                UIApplication.sharedApplication().networkActivityIndicatorVisible = showsNetworkActivityIndicator
            }
            .addDisposableTo(disposeBag)
        
        crimes
            .asObservable()
            .subscribeNext { [weak self] (crimes) in
                if crimes.count <= 0 {
                    return
                }
                if let strongSelf = self {
                    strongSelf.mapView.addAnnotationsBasedOnCrimes(crimes)
                }
            }
            .addDisposableTo(disposeBag)
    }
}
