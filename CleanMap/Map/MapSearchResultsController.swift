//
//  MapSearchResultsController.swift
//  CleanMap
//
//  Created by Tibor Molnár on 05/09/16.
//  Copyright © 2016 Black Swan Data Ltd. All rights reserved.
//

import MapKit
import RxSwift
import UIKit

protocol MapSearchResultsView {
    var viewModel: MapSearchResultsViewModelInterface! {get set}
    var networkActivityIndicatorShow: Variable<Bool> {get set}
    var results: Variable<[AnyObject]> {get set}
}

protocol MapSearchResultsDelegate {
    func mapSearchResultsController(mapSearchResultsController: MapSearchResultsController, didSelectMapItem: MKMapItem)
}

class MapSearchResultsController: UITableViewController, UISearchResultsUpdating, MapSearchResultsView {
    
    private enum Constants {
        static let reuseIdentifier = "UI"
    }
    
    var viewModel: MapSearchResultsViewModelInterface!
    
    var networkActivityIndicatorShow = Variable<Bool>(false)
    
    var results = Variable<[AnyObject]>([])
    
    let disposeBag = DisposeBag()
    
    var delegate: MapSearchResultsDelegate!
    
    init(style: UITableViewStyle, delegate: MapSearchResultsDelegate) {
        super.init(style: style)
        viewModel = MapSearchResultsViewModel(view: self)
        tableView.registerClass(DefaultTableViewCellWithSubtitleStyle.self, forCellReuseIdentifier: Constants.reuseIdentifier)
        self.delegate = delegate
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.reuseIdentifier, forIndexPath: indexPath)
        if let obj = self.results.value[indexPath.row] as? MKMapItem {
            cell.textLabel?.text = obj.name
            cell.detailTextLabel?.text = obj.placemark.country
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        guard let mapItem = results.value[indexPath.row] as? MKMapItem else {
            return
        }
        delegate.mapSearchResultsController(self, didSelectMapItem: mapItem)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.value.count
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    // MARK: UISearchResultsUpdating
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            viewModel.searchText.value = searchText
        }
    }
    
    func setupBindings() {
        networkActivityIndicatorShow
            .asObservable()
            .subscribeNext { (shouldShow) in
                UIApplication.sharedApplication().networkActivityIndicatorVisible = shouldShow
            }
            .addDisposableTo(disposeBag)
        
        results
            .asObservable()
            .subscribeNext { [weak self] (results) in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.tableView.reloadData()
            }
            .addDisposableTo(disposeBag)
    }
}

class DefaultTableViewCellWithSubtitleStyle: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
