//
//  RouteDetailViewController.swift
//  RouteMe
//
//  Created by Hesham Massoud on 24/05/16.
//  Copyright © 2016 Hesham Massoud. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire

class RouteDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var route: Route = Route()
    
    @IBOutlet weak var likeThisRouteLabel: UILabel!
    @IBOutlet weak var likeThisRouteSwitch: UISwitch!
    
    @IBAction func routeLikedAction(sender: AnyObject) {
        if likeThisRouteSwitch.on {
            likeDislikeRequest(true)
        } else {
            likeDislikeRequest(false)
        }
    }
    
    @IBOutlet weak var routeDetailTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let mapView: GMSMapView = addMapView()
        
        positionLikeSwitch(mapView)
        positionLikeLabel(mapView)
        positionTableView()
        changeTableViewBackgroundColor()
        
        self.view.backgroundColor = UIColor(hexString: Style.ColorPallete.GREY)
        likeThisRouteSwitch.tintColor = UIColor(hexString: Style.ColorPallete.RED)
        likeThisRouteSwitch.onTintColor = UIColor(hexString: Style.ColorPallete.RED)
        
        drawRoutePath(mapView)
        drawMarker(mapView)
        setLikeSwitchState()
    }
    
    func setLikeSwitchState() {
        if route.liked {
            likeThisRouteSwitch.on = true;
        } else {
            likeThisRouteSwitch.on = false;
        }
    }
    
    func likeDislikeRequest(isLike: Bool) {
        var endPointPath = ""
        if isLike {
            endPointPath = API.LikeRouteEndpoint.Path
        } else {
            endPointPath = API.DislikeRouteEndpoint.Path
        }
        let spinnerFrame: UIView = self.view.startASpinner()
        let loggedInUser = Helper.getLoggedInUser()
        let parameters = [API.LikeRouteEndpoint.Parameter.UserId: loggedInUser.id,
                          API.LikeRouteEndpoint.Parameter.TargetEntityId: route.id]
        Alamofire.request(
            .POST,
            endPointPath,
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
                    if (statusCode == API.SetPreferenceEndpoint.Response.CREATED) {
                    } else {
                        Helper.alertRequestError(responseJSON, viewController: self)
                    }
                case .Failure(let error):
                    self.alert("Fatal Error", message: "Request failed with error: \(error)", buttonText: "OK")
                }
        }
    }

    func addMapView() -> GMSMapView {
        let camera = GMSCameraPosition.cameraWithLatitude(route.startLatitude, longitude: route.startLongitude, zoom: 13)
        let mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
        self.view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.leadingAnchor.constraintEqualToAnchor(self.view.leadingAnchor).active=true
        mapView.widthAnchor.constraintEqualToAnchor(self.view.widthAnchor).active = true
        mapView.topAnchor.constraintEqualToAnchor(self.view.topAnchor).active = true
        mapView.heightAnchor.constraintEqualToConstant(Style.Height.RouteDetailMapView).active = true
        return mapView
    }

    func positionLikeSwitch(mapView: GMSMapView) {
        likeThisRouteSwitch.translatesAutoresizingMaskIntoConstraints = false
        likeThisRouteSwitch.topAnchor.constraintEqualToAnchor(mapView.bottomAnchor, constant: Style.Height.LikeSectionVerticalPadding).active = true
    }

    func positionLikeLabel(mapView: GMSMapView) {
        likeThisRouteLabel.translatesAutoresizingMaskIntoConstraints = false
        likeThisRouteLabel.topAnchor.constraintEqualToAnchor(mapView.bottomAnchor, constant: Style.Height.LikeSectionVerticalPadding).active = true
    }

    func positionTableView() {
        routeDetailTableView.widthAnchor.constraintEqualToAnchor(self.view.widthAnchor).active = true
        routeDetailTableView.delegate = self
        routeDetailTableView.dataSource = self
    }
    
    func changeTableViewBackgroundColor() {
        routeDetailTableView.backgroundView = nil
        routeDetailTableView.backgroundColor = UIColor(hexString: Style.ColorPallete.Blue)
    }

    func drawRoutePath(mapView: GMSMapView) {
        let routePolyline = route.polyline
        let gmsPath = GMSPath(fromEncodedPath: routePolyline)
        let polyline = GMSPolyline(path: gmsPath)
        polyline.map = mapView
    }
    
    func drawMarker(mapView: GMSMapView) {
        let startMarker = GMSMarker()
        startMarker.position = CLLocationCoordinate2DMake(route.startLatitude, route.startLongitude)
        startMarker.title = "Start location"
        startMarker.snippet = route.startAddress
        startMarker.map = mapView
        
        let endMarker = GMSMarker()
        endMarker.position = CLLocationCoordinate2DMake(route.endLatitude, route.endLongitude)
        endMarker.title = "End location"
        endMarker.snippet = route.endAddress
        endMarker.map = mapView
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return route.steps.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Placeholder.Title.RouteDetails
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return Style.Height.RouteDetailCells
    }
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
    {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor(hexString: Style.ColorPallete.GREY)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        clearCellContents(cell)
        addContentsToCell(cell, index: indexPath.row)
        return cell
    }
    
    func clearCellContents(cell: UITableViewCell) {
        for view in cell.subviews {
            if let label = view as? UILabel {
                label.removeFromSuperview()
            }
            if let image = view as? UIImageView {
                image.removeFromSuperview()
            }
        }
    }
    
    func addContentsToCell(cell: UITableViewCell, index: Int) {
        cell.backgroundColor = UIColor(hexString: Style.ColorPallete.GREY)
        let currentRouteStep = route.steps[index]
        let currentRouteStepTransportationMode = currentRouteStep[API.SearchEndpoint.Key.TransportationMode] as! String
        let currentRouteStepTransportationModeImagePath = Transportation.ImagePaths[currentRouteStepTransportationMode]
        
        let stepSummaryLabel = addStepSummaryToCell(cell)
        let vehicleImageView = addVehicleImageViewToCell(cell, imagePath: currentRouteStepTransportationModeImagePath!)
        let headsignLabel = addHeadsignLabel(cell, vehicleImageView: vehicleImageView)
        
        if route.isTransit {
            addTransitRouteCellContents(cell, stepIndex: index, stepSummaryLabel: stepSummaryLabel, vehicleImageView: vehicleImageView, headsignLabel: headsignLabel)
        } else {
            addNonTransitRouteCellContets(cell, stepSummaryLabel: stepSummaryLabel, vehicleImageView: vehicleImageView, headsignLabel: headsignLabel, routeStep: currentRouteStep)
        }
    }
    
    func addStepSummaryToCell(cell: UITableViewCell) -> UILabel {
        let stepSummaryLabel = UILabel()
        stepSummaryLabel.translatesAutoresizingMaskIntoConstraints = false
        stepSummaryLabel.font = Style.Font.RouteDetailCells
        cell.addSubview(stepSummaryLabel)
        stepSummaryLabel.topAnchor.constraintEqualToAnchor(cell.topAnchor, constant: 14).active = true
        stepSummaryLabel.leadingAnchor.constraintEqualToAnchor(cell.leadingAnchor, constant: 14).active = true
        stepSummaryLabel.trailingAnchor.constraintEqualToAnchor(cell.trailingAnchor, constant: 14).active = true
        return stepSummaryLabel
    }
    
    func addVehicleImageViewToCell(cell: UITableViewCell, imagePath: String) -> UIImageView {
        let vehicleImage = UIImage(named: imagePath)
        let vehicleImageView = UIImageView(image: vehicleImage!)
        cell.addSubview(vehicleImageView)
        vehicleImageView.translatesAutoresizingMaskIntoConstraints = false
        vehicleImageView.leadingAnchor.constraintEqualToAnchor(cell.leadingAnchor, constant: 14).active = true
        vehicleImageView.widthAnchor.constraintEqualToConstant(28).active = true
        vehicleImageView.heightAnchor.constraintEqualToConstant(28).active = true
        return vehicleImageView
    }
    
    func addHeadsignLabel(cell: UITableViewCell, vehicleImageView: UIImageView) -> UILabel {
        let headsignLabel = UILabel()
        headsignLabel.translatesAutoresizingMaskIntoConstraints = false
        headsignLabel.font = Style.Font.RouteDetailCells
        cell.addSubview(headsignLabel)
        headsignLabel.leadingAnchor.constraintEqualToAnchor(vehicleImageView.trailingAnchor, constant: 4).active = true
        return headsignLabel
    }
    
    func addTransitRouteCellContents(cell: UITableViewCell, stepIndex: Int, stepSummaryLabel: UILabel, vehicleImageView: UIImageView, headsignLabel: UILabel) {
        let stationsLabel = addStationsLabel(cell, stepIndex: stepIndex, stepSummaryLabel: stepSummaryLabel)
        vehicleImageView.topAnchor.constraintEqualToAnchor(stationsLabel.bottomAnchor, constant: 10).active=true
        headsignLabel.topAnchor.constraintEqualToAnchor(stationsLabel.bottomAnchor, constant: 17).active=true
        let transitStepSummary = "\(route.transitSteps[stepIndex].startTime)-\(route.transitSteps[stepIndex].endTime) (\(route.transitSteps[stepIndex].duration))"
        stepSummaryLabel.text = transitStepSummary
        headsignLabel.text = route.transitSteps[stepIndex].transportationLineHeadSign
    }
    
    func addStationsLabel(cell: UITableViewCell, stepIndex: Int, stepSummaryLabel: UILabel) -> UILabel{
        let stationsLabel = UILabel()
        stationsLabel.translatesAutoresizingMaskIntoConstraints = false
        stationsLabel.font = Style.Font.RouteDetailCells
        stationsLabel.text = "\(route.transitSteps[stepIndex].startStation)-\(route.transitSteps[stepIndex].endStation)"
        cell.addSubview(stationsLabel)
        stationsLabel.topAnchor.constraintEqualToAnchor(stepSummaryLabel.bottomAnchor, constant: 7).active = true
        stationsLabel.leadingAnchor.constraintEqualToAnchor(cell.leadingAnchor, constant: 14).active = true
        stationsLabel.trailingAnchor.constraintEqualToAnchor(cell.trailingAnchor).active = true
        stationsLabel.adjustsFontSizeToFitWidth = true
        return stationsLabel
    }
    
    func addNonTransitRouteCellContets(cell: UITableViewCell, stepSummaryLabel: UILabel, vehicleImageView: UIImageView,
                                       headsignLabel: UILabel, routeStep: AnyObject) {
        vehicleImageView.bottomAnchor.constraintEqualToAnchor(cell.bottomAnchor, constant: -10.5).active=true
        headsignLabel.bottomAnchor.constraintEqualToAnchor(cell.bottomAnchor, constant: -14).active=true
        let currentRouteStepDistance = routeStep[API.SearchEndpoint.Key.Distance] as! String
        let currentRouteStepHTMLInstruction = routeStep[API.SearchEndpoint.Key.HTMLInstruction] as! String
        setHTMLInstructionLabelText(stepSummaryLabel, htmlInstruction: currentRouteStepHTMLInstruction)
        headsignLabel.text = currentRouteStepDistance
    }
    
    func setHTMLInstructionLabelText(label: UILabel, htmlInstruction: String) {
        let styledHTMLInstruction = styleHTMLInstruction(htmlInstruction)
        let attrStr = try! NSMutableAttributedString(
            data: styledHTMLInstruction.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)!,
            options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
            documentAttributes: nil)
        label.attributedText = attrStr
        label.numberOfLines = 2
    }
    
    func styleHTMLInstruction(htmlInstruction: String) -> String {
        var styledHTMLInstruction = "\(Style.HTML.InstructionSpanTagOpenning)\(htmlInstruction)"
        styledHTMLInstruction = styledHTMLInstruction.stringByReplacingOccurrencesOfString(Style.HTML.InstructionBoldTagOpenning, withString: Style.HTML.InstructionBoldSpanTagOpenning)
        styledHTMLInstruction = styledHTMLInstruction.stringByReplacingOccurrencesOfString(Style.HTML.InstructionBoldTagClosing, withString: Style.HTML.InstructionSpanTagClosing)
        styledHTMLInstruction = "\(styledHTMLInstruction)\(Style.HTML.InstructionSpanTagClosing)"
        return styledHTMLInstruction
    }
    
}