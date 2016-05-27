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

    var searchResultController: SearchResultsController!
    var isEditingStart: Bool!
    var autocompleteResultsArray = [String]()
    var searchResultsArray = [Route]()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        tabBarItem = UITabBarItem(title: "Find Routes", image: UIImage(named: "bus-tab"), tag: 2)
    }

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
        self.view.backgroundColor = UIColor(hexString: Style.ColorPallete.GREY)
        styleSearchFieldsText()
        // Do any additional setup after loading the view.
    }
    
    func styleSearchFieldsText() {
        startPointField.textColor = UIColor(hexString: Style.ColorPallete.Blue)
        endPointField.textColor = UIColor(hexString: Style.ColorPallete.Blue)
        startPointField.font = Style.Font.AutocompleteResults
        endPointField.font = Style.Font.AutocompleteResults
    }

    func setTextFieldsBottomBorders() {
        Helper.setTextFieldBottomBorder(startPointField)
        Helper.setTextFieldBottomBorder(endPointField)
    }

    func searchRequest(startPoint: String, endPoint: String) {
        let spinnerFrame: UIView = self.view.startASpinner()
        let loggedInUser = Helper.getLoggedInUser()
        let parameters = [API.SearchEndpoint.Parameter.StartPoint: startPoint,
                          API.SearchEndpoint.Parameter.EndPoint: endPoint,
                          API.SearchEndpoint.Parameter.UserId: loggedInUser.id]
        Alamofire.request(
            .POST,
            API.SearchEndpoint.Path,
            parameters: parameters,
            encoding:.JSON)
            .responseJSON
            {
                response in
                self.view.stopSpinner(spinnerFrame)
                switch response.result {
                case .Success(let JSON):
                    let statusCode = (response.response?.statusCode)!
                    let responseJSON = JSON as! NSDictionary
                    if (statusCode == API.SearchEndpoint.Response.Ok) {
                        self.processResultIntoTableView(responseJSON)
                    } else {
                        Helper.alertRequestError(responseJSON, viewController: self)
                    }
                case .Failure(let error):
                    self.alert("Fatal Error", message: "Request failed with error: \(error)", buttonText: "OK")
                }
        }
    }

    func processResultIntoTableView(responseJSON: NSDictionary) {
        let result = responseJSON[API.SearchEndpoint.Key.RouteResults] as! [Dictionary<String, AnyObject>]
        for route in result {
            var newRoute: Route
            let routeId = route[API.SearchEndpoint.Key.PredictionIoId] as! String
            let isTransitRoute = route[API.SearchEndpoint.Key.IsTransit] as! Bool
            let routeSummary = route[API.SearchEndpoint.Key.Summary] as! String
            let steps = route[API.SearchEndpoint.Key.Steps]! as AnyObject
            let polyline = route[API.SearchEndpoint.Key.Polyline] as! String
            let startAddress = route[API.SearchEndpoint.Key.StartAddress] as! String
            let endAddress = route[API.SearchEndpoint.Key.EndAddress] as! String
            let startLatitude = route[API.SearchEndpoint.Key.StartLocationLat] as! Double
            let startLongitude = route[API.SearchEndpoint.Key.StartLocationLng] as! Double
            let endLatitude = route[API.SearchEndpoint.Key.EndLocationLat] as! Double
            let endLongitude = route[API.SearchEndpoint.Key.EndLocationLng] as! Double
            let liked = route[API.SearchEndpoint.Key.Liked] as! Bool
            let explanation = route[API.SearchEndpoint.Key.Explanations] as! String
            newRoute = Route(id: routeId,
                             isTransit: isTransitRoute,
                             summary: routeSummary,
                             steps: steps as! [AnyObject],
                             polyline: polyline,
                             startAddress: startAddress,
                             endAddress: endAddress,
                             startLatitude: startLatitude,
                             startLongitude: startLongitude,
                             endLatitude: endLatitude,
                             endLongitude: endLongitude,
                             liked: liked,
                             explanation: explanation)
            self.searchResultsArray.append(newRoute)
        }
        self.routeResultsTableView.reloadData()
    }

    /**
     Searchbar when text change
     
     - parameter searchBar:  searchbar UI
     - parameter searchText: searchtext description
     */
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        let filter = GMSAutocompleteFilter()
        filter.type = .Address
        filter.country = GoogleMapsAPI.Autocomplete.BiasCountry
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
    
    func insertAddress(address: String, isStart: Bool) {
        if isStart {
            startPointField.text = address
        } else {
            endPointField.text = address
        }
        searchForRoutes()
    }
    
    func searchForRoutes() {
        let startPoint = startPointField.text
        let endPoint = endPointField.text
        clearResultsTable()
        if (!(startPoint?.isEmpty)! && !(endPoint?.isEmpty)!) {
            searchRequest(startPoint!, endPoint: endPoint!)
        }
    }
    
    func clearResultsTable() {
        self.searchResultsArray = [Route] ()
        self.routeResultsTableView.reloadData()
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
        return Style.Height.RouteSearchResultsCells
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("customcell", forIndexPath: indexPath) as! RouteSearchResultTableViewCell
        addContentsToCell(cell, index: indexPath.row)
        return cell
    }

    func addContentsToCell(cell: RouteSearchResultTableViewCell, index: Int) {
        cell.backgroundColor = UIColor(hexString: Style.ColorPallete.GREY)
        let currentRoute = searchResultsArray[index]
        let currentRouteSteps = currentRoute.steps
        cell.routeSummaryLabel.text = currentRoute.summary
        var lastAddedView: UIView = UIView()
        if !currentRoute.isTransit {
            let transportationMode = currentRouteSteps[0][API.SearchEndpoint.Key.TransportationMode] as! String
            lastAddedView = addNonTransitTransportationModeImageToCell(cell, transportationMode: transportationMode)
        } else {
            lastAddedView = addTransitTransportationModeContentsToCell(cell, routeSteps: currentRoute.transitSteps)
        }
        addExplanationImageToCell(cell, lastAddedView: lastAddedView, explanation: currentRoute.explanation)
        
    }
    
    func addExplanationImageToCell(cell: RouteSearchResultTableViewCell, lastAddedView: UIView, explanation: String) {
        let imagePath = Explanations.ImagePaths[explanation]
        let image = UIImage(named: imagePath!)
        let imageView = UIImageView(image: image!)
        cell.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraintEqualToAnchor(cell.topAnchor, constant: 47).active=true
        imageView.widthAnchor.constraintEqualToConstant(28).active = true
        imageView.heightAnchor.constraintEqualToConstant(28).active = true
        imageView.leadingAnchor.constraintEqualToAnchor(lastAddedView.trailingAnchor, constant: 14).active = true
        
    }

    func addNonTransitTransportationModeImageToCell(cell: RouteSearchResultTableViewCell, transportationMode: String) -> UIView {
        let imagePath = Transportation.ImagePaths[transportationMode]
        let image = UIImage(named: imagePath!)
        let imageView = UIImageView(image: image!)
        imageView.frame = CGRect(x: 8, y: 47, width: 28, height: 28)
        cell.addSubview(imageView)
        return imageView
    }

    func addTransitTransportationModeContentsToCell(cell: RouteSearchResultTableViewCell, routeSteps: [TransitStep]) -> UIView{
        var previousLabel: AnyObject?
        for (index, step) in routeSteps.enumerate() {
            let transportationImageView = addTransitTransportationImageToCell(cell, step: step, isFirstStep: index == 0, previousLabel: previousLabel)
            let transportationShortNameLabel = addLineShortNameLabelToCell(cell, step: step, transportationImageView: transportationImageView)
            previousLabel = transportationShortNameLabel as UILabel
        }
        return previousLabel as! UIView
    }

    func addTransitTransportationImageToCell(cell: RouteSearchResultTableViewCell, step: TransitStep, isFirstStep: Bool, previousLabel: AnyObject?) -> UIImageView {
        var imagePath: String = ""
        let transportationMode = step.transportationMode
        imagePath = Transportation.ImagePaths[transportationMode]!
        let image = UIImage(named: imagePath)
        let imageView = UIImageView(image: image!)
        cell.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraintEqualToAnchor(cell.topAnchor, constant: 47).active=true
        imageView.widthAnchor.constraintEqualToConstant(28).active = true
        imageView.heightAnchor.constraintEqualToConstant(28).active = true
        if isFirstStep {
            imageView.leadingAnchor.constraintEqualToAnchor(cell.leadingAnchor, constant: 7).active = true
        } else {
            if let previousLabelTrailingAnchor = previousLabel?.trailingAnchor {
                imageView.leadingAnchor.constraintEqualToAnchor(previousLabelTrailingAnchor, constant: 7).active = true
            }
        }
        return imageView
    }

    func addLineShortNameLabelToCell(cell: RouteSearchResultTableViewCell, step: TransitStep, transportationImageView: UIImageView) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        let transportationVehicleShortName = step.transportationVehicleShortName
        label.text = transportationVehicleShortName

        let transportationLineColorCode = step.transportationLineColorCode
        if transportationLineColorCode != "" {
            label.backgroundColor = UIColor(hexString: transportationLineColorCode)
            label.textColor = UIColor.whiteColor()
            label.layer.cornerRadius = 2.0
            label.clipsToBounds = true
        }
        cell.addSubview(label)
        label.topAnchor.constraintEqualToAnchor(cell.topAnchor, constant: 47).active=true
        label.heightAnchor.constraintEqualToConstant(28).active = true
        label.leadingAnchor.constraintEqualToAnchor(transportationImageView.trailingAnchor, constant: 3).active = true
        label.sizeToFit()
        return label
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