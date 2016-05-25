//
//  SearchRoutesViewController.swift
//  RouteMe
//
//  Created by Hesham Massoud on 23/05/16.
//  Copyright © 2016 Hesham Massoud. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire
import SwiftHEXColors



class SearchRoutesViewController: UIViewController, UISearchBarDelegate, UITextFieldDelegate, InsertAddressOnTextfield, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var startPointField: UITextField!
    @IBOutlet weak var endPointField: UITextField!
    @IBOutlet weak var routeResultsTableView: UITableView!
    
    var searchResultController: SearchResultsController!
    var isEditingStart: Bool!
    var autocompleteResultsArray = [String]()
    var searchResultsArray = [Route]()
    
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        searchResultController = SearchResultsController()
        searchResultController.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        routeResultsTableView.delegate = self
        routeResultsTableView.dataSource = self
        
        setTextFieldsBottomBorders()
        
        // Do any additional setup after loading the view.
    }
    
    
    func setTextFieldsBottomBorders() {
        Helper.setTextFieldBottomBorder(startPointField)
        Helper.setTextFieldBottomBorder(endPointField)
    }
    
    @IBAction func startPointEnterAction(sender: AnyObject) {
        isEditingStart = true
        let searchController = UISearchController(searchResultsController: searchResultController)
        searchController.searchBar.delegate = self
        self.presentViewController(searchController, animated: true, completion: nil)
    }
    
    @IBAction func endPointEnterAction(sender: AnyObject) {
        isEditingStart = false
        let searchController = UISearchController(searchResultsController: searchResultController)
        searchController.searchBar.delegate = self
        self.presentViewController(searchController, animated: true, completion: nil)
    }
    
    func searchForRoutes() {
        let startPoint = startPointField.text
        let endPoint = endPointField.text
        clearResultsTable()
        if (!(startPoint?.isEmpty)! && !(endPoint?.isEmpty)!) {
            searchRequest(startPoint!, endPoint: endPoint!)
        }
    }
    
    func searchRequest(startPoint: String, endPoint: String) {
        let spinnerFrame: UIView = self.view.startASpinner()
        let parameters = ["startPoint": startPoint, "endPoint": endPoint]
        Alamofire.request(
            .POST,
            "http://routeme-api.us-east-1.elasticbeanstalk.com/api/search",
            parameters: parameters,
            encoding:.JSON)
            .responseJSON
            {
                response in
                self.view.stopSpinner(spinnerFrame)
                switch response.result {
                case .Success(let JSON):
                    let HTTP_STATUS_CODE_OK: Int = 200
                    let statusCode = (response.response?.statusCode)!
                    let responseJSON = JSON as! NSDictionary
                    if (statusCode == HTTP_STATUS_CODE_OK) {
                        let results = responseJSON["routeResults"] as! [Dictionary<String, AnyObject>]
                        for route in results {
                            var newRoute: Route;
                            let routeId = route["predictionIoId"] as! String
                            let isTransitRoute = route["transit"] as! Bool
                            let routeSummary = route["routeSummary"] as! String
                            let steps = route["steps"]! as AnyObject
                            let polyline = route["overviewPolyLine"] as! String
                            let startAddress = route["startAddress"] as! String
                            let endAddress = route["endAddress"] as! String
                            newRoute = Route(id: routeId, isTransit: isTransitRoute, summary: routeSummary, steps: steps as! [AnyObject], polyline: polyline, startAddress: startAddress, endAddress: endAddress)
                            self.searchResultsArray.append(newRoute)
                        }
                        self.routeResultsTableView.reloadData()
                    } else {
                        Helper.alertRequestError(responseJSON, viewController: self)
                    }
                case .Failure(let error):
                    self.alert("Fatal Error", message: "Request failed with error: \(error)", buttonText: "OK")
                }
        }
    }
    
    func clearResultsTable() {
        self.searchResultsArray = [Route] ()
        self.routeResultsTableView.reloadData()
    }
    
    func InsertAddress(address: String, isStart: Bool) {
        if isStart {
            startPointField.text = address
        } else {
            endPointField.text = address
        }
        searchForRoutes()
    }
    
    /**
     Searchbar when text change
     
     - parameter searchBar:  searchbar UI
     - parameter searchText: searchtext description
     */
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        let filter = GMSAutocompleteFilter()
        filter.type = .Address
        filter.country = "de"
        let placeClient = GMSPlacesClient()
        placeClient.autocompleteQuery(searchText, bounds: nil, filter: filter) { (results, error: NSError?) -> Void in
            
            self.autocompleteResultsArray.removeAll()
            if results == nil {
                return
            }
            
            for result in results! {
                let result = result as GMSAutocompletePrediction
                self.autocompleteResultsArray.append(result.attributedFullText.string)
            }
            
            self.searchResultController.reloadDataWithArray(self.autocompleteResultsArray, isStart: self.isEditingStart)
            
        }
    }
    
    func searchBar(searchBar: UISearchBar, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        let isCharacterInLetterSet = text.rangeOfCharacterFromSet(NSCharacterSet.letterCharacterSet()) != nil
        let isCharacterInWhiteSpaceSet = text.rangeOfCharacterFromSet(NSCharacterSet.whitespaceCharacterSet()) != nil
        let isCharacterBackspace = text.characters.count == 0
        if isCharacterBackspace || isCharacterInLetterSet || isCharacterInWhiteSpaceSet  {
            return true
        } else {
            return false
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResultsArray.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100.0
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("customcell", forIndexPath: indexPath) as! RouteSearchResultTableViewCell
        
        let currentRoute = searchResultsArray[indexPath.row]
        let currentRouteSteps = currentRoute.steps
        cell.routeSummaryLabel.text = currentRoute.summary
        if !currentRoute.isTransit {
            let transportationMode = currentRouteSteps[0]["transportationMode"] as! String
            let imagePath = Route.vehicleNamingMap[transportationMode]
            let image = UIImage(named: imagePath!)
            let imageView = UIImageView(image: image!)
            imageView.frame = CGRect(x: 8, y: 47, width: 28, height: 28)
            cell.addSubview(imageView)
        } else {
            var previousLabel: AnyObject?
            for (index, step) in currentRouteSteps.enumerate() {
                var imagePath: String = ""
                if let transportationMode = step["transportationMode"] as? String {
                    imagePath = Route.vehicleNamingMap[transportationMode]!
                }
                let image = UIImage(named: imagePath)
                let imageView = UIImageView(image: image!)
                cell.addSubview(imageView)
                imageView.translatesAutoresizingMaskIntoConstraints = false
                
                imageView.topAnchor.constraintEqualToAnchor(cell.topAnchor, constant: 47).active=true
                imageView.widthAnchor.constraintEqualToConstant(28).active = true
                imageView.heightAnchor.constraintEqualToConstant(28).active = true
                if index == 0 {
                    imageView.leadingAnchor.constraintEqualToAnchor(cell.leadingAnchor, constant: 7).active = true
                } else {
                    if let previousLabelTrailingAnchor = previousLabel?.trailingAnchor {
                        imageView.leadingAnchor.constraintEqualToAnchor(previousLabelTrailingAnchor, constant: 7).active = true
                    }
                }
                let label = UILabel()
                label.translatesAutoresizingMaskIntoConstraints = false
                if let transportationVehicleShortName = step["transportationVehicleShortName"] as? String {
                    label.text = transportationVehicleShortName
                }
                if let transportationLineColorCode = step["transportationLineColorCode"] as? String {
                    label.backgroundColor = UIColor(hexString: transportationLineColorCode)
                    label.textColor = UIColor.whiteColor()
                }
                
                label.layer.cornerRadius = 2.0
                label.clipsToBounds = true
                cell.addSubview(label)
                label.topAnchor.constraintEqualToAnchor(cell.topAnchor, constant: 47).active=true
                label.heightAnchor.constraintEqualToConstant(28).active = true
                label.leadingAnchor.constraintEqualToAnchor(imageView.trailingAnchor, constant: 3).active = true
                label.sizeToFit()
                previousLabel = label as UILabel
            }
        }
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if  segue.identifier == "showRouteDetailViewSegue", let destination = segue.destinationViewController as? RouteDetailViewController, routeIndex = routeResultsTableView.indexPathForSelectedRow?.row {
            destination.route = searchResultsArray[routeIndex]
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("showRouteDetailViewSegue", sender: nil)
        routeResultsTableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}