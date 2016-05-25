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
        
        routeDetailTableView.delegate = self
        routeDetailTableView.dataSource = self
        
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
        return 10
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Route details"
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        let StepSummaryLabel = UILabel()
        StepSummaryLabel.translatesAutoresizingMaskIntoConstraints = false
        StepSummaryLabel.text = "00:47 AM- 00:50 AM"
        StepSummaryLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 15)!
        cell.addSubview(StepSummaryLabel)
        StepSummaryLabel.topAnchor.constraintEqualToAnchor(cell.topAnchor, constant: 14).active = true
        StepSummaryLabel.leadingAnchor.constraintEqualToAnchor(cell.leadingAnchor, constant: 14).active = true
        
        let stationsLabel = UILabel()
        stationsLabel.translatesAutoresizingMaskIntoConstraints = false
        stationsLabel.text = "Münchner Freiheit - Marienplatz"
        stationsLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 15)!
        cell.addSubview(stationsLabel)
        stationsLabel.topAnchor.constraintEqualToAnchor(StepSummaryLabel.bottomAnchor, constant: 7).active = true
        stationsLabel.leadingAnchor.constraintEqualToAnchor(cell.leadingAnchor, constant: 14).active = true
        
        
        let vehicleImage = UIImage(named: "bus.png")
        let vehicleImageView = UIImageView(image: vehicleImage!)
        cell.addSubview(vehicleImageView)
        vehicleImageView.translatesAutoresizingMaskIntoConstraints = false
        vehicleImageView.topAnchor.constraintEqualToAnchor(stationsLabel.bottomAnchor, constant: 10).active=true
        vehicleImageView.leadingAnchor.constraintEqualToAnchor(cell.leadingAnchor, constant: 14).active = true
        vehicleImageView.widthAnchor.constraintEqualToConstant(28).active = true
        vehicleImageView.heightAnchor.constraintEqualToConstant(28).active = true
        
        let headsignLabel = UILabel()
        headsignLabel.translatesAutoresizingMaskIntoConstraints = false
        headsignLabel.text = "(Klinikium Großhadern)"
        headsignLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 15)!
        cell.addSubview(headsignLabel)
        headsignLabel.topAnchor.constraintEqualToAnchor(stationsLabel.bottomAnchor, constant: 17).active=true
        headsignLabel.leadingAnchor.constraintEqualToAnchor(vehicleImageView.trailingAnchor, constant: 4).active = true
        
        
        
        return cell
    }
}