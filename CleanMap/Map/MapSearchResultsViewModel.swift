//
//  MapSearchResultsViewModel.swift
//  CleanMap
//
//  Created by Tibor Molnár on 06/09/16.
//  Copyright © 2016 Black Swan Data Ltd. All rights reserved.
//

import Foundation
import RxSwift

protocol MapSearchResultsViewModelInterface {
    var view: MapSearchResultsView! {get set}
    var searchText: Variable<String> {get set}
}

struct MapSearchResultsViewModel: MapSearchResultsViewModelInterface {
    
    fileprivate enum ViewModelConstants {
        static let throttleInterval = 0.7
        static let scheduler = MainScheduler.instance
    }
    
    var view: MapSearchResultsView!
    
    var searchText = Variable<String>("")
    
    fileprivate let disposeBag = DisposeBag()
    
    fileprivate let localSearch = LocalSearch()
    
    init(view: MapSearchResultsView) {
        self.view = view
        setupBindings()
    }
    
    fileprivate func setupBindings() {
        searchText
            .asObservable()
            .filter({ (newValue) -> Bool in
                return newValue.characters.count >= 5
            })
            .throttle(ViewModelConstants.throttleInterval, scheduler: ViewModelConstants.scheduler)
            .distinctUntilChanged()
            .subscribe({ (searchText) in
                guard let searchText = searchText.element else {
                    return
                }
                self.view.networkActivityIndicatorShow.value = true
                self.localSearch.executeQuery(searchText,
                                              successBlock: { (response) in
                                                self.view.networkActivityIndicatorShow.value = false
                                                if let mapItems = response?.mapItems {
                                                    self.view.results.value = mapItems
                                                }
                },
                                              failureBlock: { (error) in
                                                self.view.networkActivityIndicatorShow.value = false
                                                print(error?.description ?? "Error in localsearch callback")
                }
                )
            })
            .addDisposableTo(disposeBag)
    }
}
