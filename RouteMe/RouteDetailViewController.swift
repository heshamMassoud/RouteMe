//
//  RouteDetailViewController.swift
//  RouteMe
//
//  Created by Hesham Massoud on 24/05/16.
//  Copyright © 2016 Hesham Massoud. All rights reserved.
//

import UIKit
import GoogleMaps

class RouteDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var route: Route = Route()
    
    @IBOutlet weak var likeThisRouteLabel: UILabel!
    @IBOutlet weak var likeThisRouteSwitch: UISwitch!
    @IBAction func routeLikedAction(sender: AnyObject) {
        
    }
    @IBOutlet weak var routeDetailTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let mapView: GMSMapView = addMapView()
        
        positionLikeSwitch(mapView)
        positionLikeLabel(mapView)
        positionTableView()
        
        self.navigationController?.navigationBar.hidden = true
        
        drawRoutePath(mapView)
        drawMarker(mapView)
    }

    func addMapView() -> GMSMapView {
        let camera = GMSCameraPosition.cameraWithLatitude(48.1622980, longitude: 11.5554340, zoom: 10)
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

    func drawRoutePath(mapView: GMSMapView) {
        let routePolyline = route.polyline
        let gmsPath = GMSPath(fromEncodedPath: routePolyline)
        let polyline = GMSPolyline(path: gmsPath)
        polyline.map = mapView
    }
    
    func drawMarker(mapView: GMSMapView) {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(48.1622980, 11.5554340)
        marker.title = "München"
        marker.snippet = route.startAddress
        marker.map = mapView
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
        let currentRouteStep = route.steps[index]
        let currentRouteStepTransportationMode = currentRouteStep[Key.RouteStep.TransportationMode] as! String
        let currentRouteStepTransportationModeImagePath = Transportation.ImagePaths[currentRouteStepTransportationMode]
        
        let stepSummaryLabel = addStepSummaryToCell(cell)
        let vehicleImageView = addVehicleImageViewToCell(cell, imagePath: currentRouteStepTransportationModeImagePath!)
        let headsignLabel = addHeadsignLabel(cell, vehicleImageView: vehicleImageView)
        
        if route.isTransit {
            addTransitRouteCellContents(cell, stepSummaryLabel: stepSummaryLabel, vehicleImageView: vehicleImageView, headsignLabel: headsignLabel)
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
    
    func addTransitRouteCellContents(cell: UITableViewCell, stepSummaryLabel: UILabel, vehicleImageView: UIImageView, headsignLabel: UILabel) {
        let stationsLabel = addStationsLabel(cell, stepSummaryLabel: stepSummaryLabel)
        vehicleImageView.topAnchor.constraintEqualToAnchor(stationsLabel.bottomAnchor, constant: 10).active=true
        headsignLabel.topAnchor.constraintEqualToAnchor(stationsLabel.bottomAnchor, constant: 17).active=true
        stepSummaryLabel.text = route.summary
        headsignLabel.text = "to Klinikium Großhadern"
    }
    
    func addStationsLabel(cell: UITableViewCell, stepSummaryLabel: UILabel) -> UILabel{
        let stationsLabel = UILabel()
        stationsLabel.translatesAutoresizingMaskIntoConstraints = false
        stationsLabel.font = Style.Font.RouteDetailCells
        stationsLabel.text = "Münchner Freiheit - Marienplatz"
        cell.addSubview(stationsLabel)
        stationsLabel.topAnchor.constraintEqualToAnchor(stepSummaryLabel.bottomAnchor, constant: 7).active = true
        stationsLabel.leadingAnchor.constraintEqualToAnchor(cell.leadingAnchor, constant: 14).active = true
        return stationsLabel
    }
    
    func addNonTransitRouteCellContets(cell: UITableViewCell, stepSummaryLabel: UILabel, vehicleImageView: UIImageView,
                                       headsignLabel: UILabel, routeStep: AnyObject) {
        vehicleImageView.bottomAnchor.constraintEqualToAnchor(cell.bottomAnchor, constant: -10.5).active=true
        headsignLabel.bottomAnchor.constraintEqualToAnchor(cell.bottomAnchor, constant: -14).active=true
        let currentRouteStepDistance = routeStep[Key.RouteStep.NonTransit.Distance] as! String
        let currentRouteStepHTMLInstruction = routeStep[Key.RouteStep.NonTransit.HTMLInstruction] as! String
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