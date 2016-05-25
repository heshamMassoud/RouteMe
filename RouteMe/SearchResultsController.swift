//
//  SearchResultsController.swift
//  PlacesLookup
//
//  Created by Malek T. on 9/30/15.
//  Copyright © 2015 Medigarage Studios LTD. All rights reserved.
//

import UIKit

protocol InsertAddressOnTextfield{
    func InsertAddress(address: String, isStart: Bool)
}

class SearchResultsController: UITableViewController {

    var autocompleteResults: [String]!
    var isEditingStartPoint: Bool!
    var delegate: InsertAddressOnTextfield!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.autocompleteResults = Array()
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cellIdentifier")
        self.view.backgroundColor = UIColor(hexString: Style.ColorPallete.GREY)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.autocompleteResults.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellIdentifier", forIndexPath: indexPath)
        styleCell(cell, index: indexPath.row)
        return cell
    }
    
    func styleCell(cell: UITableViewCell, index: Int) {
        cell.backgroundColor = UIColor(hexString: Style.ColorPallete.GREY)
        cell.textLabel?.text = self.autocompleteResults[index]
        cell.textLabel?.textColor = UIColor(hexString: Style.ColorPallete.Blue)
        cell.textLabel?.font = Style.Font.AutocompleteResults
    }

    override func tableView(tableView: UITableView,
                            didSelectRowAtIndexPath indexPath: NSIndexPath){
        self.dismissViewControllerAnimated(true, completion: nil)
        let address: String = self.autocompleteResults[indexPath.row]
        self.delegate.InsertAddress(address, isStart: isEditingStartPoint)
    }

    func reloadDataWithArray(array:[String], isStart: Bool){
        self.autocompleteResults = array
        self.tableView.reloadData()
        self.isEditingStartPoint = isStart
    }
}
