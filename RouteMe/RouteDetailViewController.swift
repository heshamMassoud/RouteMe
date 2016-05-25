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
        
        
        
        let camera = GMSCameraPosition.cameraWithLatitude(48.1622980, longitude: 11.5554340, zoom: 10)
        
        let mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
        mapView.myLocationEnabled = true
        self.view.addSubview(mapView)
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        likeThisRouteLabel.translatesAutoresizingMaskIntoConstraints = false
        likeThisRouteSwitch.translatesAutoresizingMaskIntoConstraints = false
        
        
        mapView.leadingAnchor.constraintEqualToAnchor(self.view.leadingAnchor).active=true
        mapView.widthAnchor.constraintEqualToAnchor(self.view.widthAnchor).active = true
        mapView.topAnchor.constraintEqualToAnchor(self.view.topAnchor).active = true
        mapView.heightAnchor.constraintEqualToConstant(200).active = true
        
        likeThisRouteSwitch.topAnchor.constraintEqualToAnchor(mapView.bottomAnchor, constant: 14).active = true
        likeThisRouteLabel.topAnchor.constraintEqualToAnchor(mapView.bottomAnchor, constant: 14).active = true
        
        routeDetailTableView.widthAnchor.constraintEqualToAnchor(self.view.widthAnchor).active = true
        
        routeDetailTableView.delegate = self
        routeDetailTableView.dataSource = self
        
        self.navigationController?.navigationBar.hidden = true
        
        drawRoutePath(mapView)
        drawMarker(mapView)
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
        return "Route details"
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
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

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        clearCellContents(cell)
        
        let currentRouteStep = route.steps[indexPath.row]
        let currentRouteStepTransportationMode = currentRouteStep["transportationMode"] as! String
        let currentRouteStepTransportationModeImagePath = Route.vehicleNamingMap[currentRouteStepTransportationMode]
        
        let StepSummaryLabel = UILabel()
        StepSummaryLabel.translatesAutoresizingMaskIntoConstraints = false
        StepSummaryLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 15)!
        cell.addSubview(StepSummaryLabel)
        StepSummaryLabel.topAnchor.constraintEqualToAnchor(cell.topAnchor, constant: 14).active = true
        StepSummaryLabel.leadingAnchor.constraintEqualToAnchor(cell.leadingAnchor, constant: 14).active = true
        StepSummaryLabel.trailingAnchor.constraintEqualToAnchor(cell.trailingAnchor, constant: 14).active = true
        
        let vehicleImage = UIImage(named: currentRouteStepTransportationModeImagePath!)
        let vehicleImageView = UIImageView(image: vehicleImage!)
        cell.addSubview(vehicleImageView)
        vehicleImageView.translatesAutoresizingMaskIntoConstraints = false
        vehicleImageView.leadingAnchor.constraintEqualToAnchor(cell.leadingAnchor, constant: 14).active = true
        vehicleImageView.widthAnchor.constraintEqualToConstant(28).active = true
        vehicleImageView.heightAnchor.constraintEqualToConstant(28).active = true
        
        let headsignLabel = UILabel()
        headsignLabel.translatesAutoresizingMaskIntoConstraints = false
        headsignLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 15)!
        cell.addSubview(headsignLabel)
        headsignLabel.leadingAnchor.constraintEqualToAnchor(vehicleImageView.trailingAnchor, constant: 4).active = true
        
        if route.isTransit {
            let stationsLabel = UILabel()
            stationsLabel.translatesAutoresizingMaskIntoConstraints = false
            stationsLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 15)!
            cell.addSubview(stationsLabel)
            stationsLabel.topAnchor.constraintEqualToAnchor(StepSummaryLabel.bottomAnchor, constant: 7).active = true
            stationsLabel.leadingAnchor.constraintEqualToAnchor(cell.leadingAnchor, constant: 14).active = true
            
            
            vehicleImageView.topAnchor.constraintEqualToAnchor(stationsLabel.bottomAnchor, constant: 10).active=true
            headsignLabel.topAnchor.constraintEqualToAnchor(stationsLabel.bottomAnchor, constant: 17).active=true
            
            StepSummaryLabel.text = route.summary
            stationsLabel.text = "Münchner Freiheit - Marienplatz"
            headsignLabel.text = "to Klinikium Großhadern"
        } else {
            
            vehicleImageView.bottomAnchor.constraintEqualToAnchor(cell.bottomAnchor, constant: -10.5).active=true
            headsignLabel.bottomAnchor.constraintEqualToAnchor(cell.bottomAnchor, constant: -14).active=true
            
            let currentRouteStepDistance = currentRouteStep["distance"] as! String
            var currentRouteStepHTMLInstruction = currentRouteStep["htmlIntruction"] as! String
            currentRouteStepHTMLInstruction = "<span style='font-family: HelveticaNeue-Thin !important; font-size: 15px'>\(currentRouteStepHTMLInstruction)"
            currentRouteStepHTMLInstruction = currentRouteStepHTMLInstruction.stringByReplacingOccurrencesOfString("<b>", withString: "<span style='font-family: HelveticaNeue-Light !important; font-size: 15px'>")
            currentRouteStepHTMLInstruction = currentRouteStepHTMLInstruction.stringByReplacingOccurrencesOfString("</b>", withString: "</span>")
            currentRouteStepHTMLInstruction = "\(currentRouteStepHTMLInstruction)</span>"
            //let fontAttribute = [ NSFontAttributeName: UIFont(name: "HelveticaNeue-Thin", size: 15)! ]
            let attrStr = try! NSMutableAttributedString(
                data: currentRouteStepHTMLInstruction.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)!,
                options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
                documentAttributes: nil)
            //let range = NSMakeRange(0, attrStr.length)
            //attrStr.addAttributes(fontAttribute, range: range)
            StepSummaryLabel.attributedText = attrStr
            StepSummaryLabel.numberOfLines = 2
            //stationsLabel.attributedText = attrStr
            headsignLabel.text = currentRouteStepDistance
        }
        return cell
    }
}