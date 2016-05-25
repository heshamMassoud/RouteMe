//
//  TravelModePreferenceViewController.swift
//  RouteMe
//
//  Created by Hesham Massoud on 22/05/16.
//  Copyright © 2016 Hesham Massoud. All rights reserved.
//

import UIKit

class TravelModePreferenceViewController: UITableViewController {
    var transportationModes = [
        Transportation(label: "Ubahn", imagePath: "ubahn.png"),
        Transportation(label: "Sbahn", imagePath: "sbahn.png"),
        Transportation(label: "Bus", imagePath: "bus.png"),
        Transportation(label: "Tram", imagePath: "tram.png"),
        Transportation(label: "Bike", imagePath: "bike.png"),
        Transportation(label: "Walking", imagePath: "walking.png"),
        Transportation(label: "Driving", imagePath: "car.png"),
        
    ]
    
    @IBAction func saveButtonTapped(sender: AnyObject) {
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transportationModes.count
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! TravelModePreferenceViewCell
        let transportation = transportationModes[indexPath.row]
        let image = UIImage(named: transportation.imagePath)
        cell.cellImage?.image = image
        cell.cellImage?.contentMode = .ScaleAspectFit
        
        
        return cell
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCellWithIdentifier("headerCell")
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70.0
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100;
    }
    
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return .None
    }
    
    override func tableView(tableView: UITableView, shouldIndentWhileEditingRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    override func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        let movedObject = transportationModes[sourceIndexPath.row]
        transportationModes.removeAtIndex(sourceIndexPath.row)
        transportationModes.insert(movedObject, atIndex: destinationIndexPath.row)
    }
    
    override func viewDidLoad() {
        self.navigationItem.rightBarButtonItem?.title = "Save"
        
        self.tableView.editing = true
    }
    
    
}
