//
//  TravelModePreferenceViewController.swift
//  RouteMe
//
//  Created by Hesham Massoud on 22/05/16.
//  Copyright © 2016 Hesham Massoud. All rights reserved.
//

import UIKit

class TravelModePreferenceViewController: UITableViewController {
    var transportationModes = Transportation.Modes
    
    @IBAction func saveButtonTapped(sender: AnyObject) {
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Transportation.Modes.count
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! TravelModePreferenceViewCell
        addCellContents(cell, index: indexPath.row)
        return cell
    }
    
    func addCellContents(cell: TravelModePreferenceViewCell, index: Int) {
        cell.backgroundColor = UIColor(hexString: Style.ColorPallete.GREY)
        let transportation = transportationModes[index]
        let image = UIImage(named: Transportation.ImagePaths[transportation]!)
        cell.cellImage?.image = image
        cell.cellImage?.contentMode = .ScaleAspectFit
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCellWithIdentifier("headerCell")
        cell!.backgroundColor = UIColor(hexString: Style.ColorPallete.GREY)
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
        self.tableView.editing = true
        self.view.backgroundColor = UIColor(hexString: Style.ColorPallete.GREY)
    }
    
}
