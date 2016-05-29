//
//  ViewController.swift
//  TinderSwipeCardsSwift
//
//  Created by Gao Chao on 4/30/15.
//  Copyright (c) 2015 gcweb. All rights reserved.
//

import UIKit
import Alamofire

class RouteTypePreferenceViewController: UIViewController {
    @IBOutlet weak var leastTimeButton: UIButton!
    @IBOutlet weak var leastChangesButton: UIButton!
    @IBOutlet weak var leastTimeLabel: UILabel!
    @IBOutlet weak var leastChangesLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    var transportationModePreference: [String] = []
    var leastTimePreference: Int = 0
    var leastChangesPreference: Int = 1

    @IBAction func leastTimeTapAction(sender: AnyObject) {
        leastTimeButton.addShadow()
        leastChangesButton.removeShadow()
        leastTimePreference = 0
        leastChangesPreference = 1
    }

    @IBAction func leastChangesTapAction(sender: AnyObject) {
        leastChangesButton.addShadow()
        leastTimeButton.removeShadow()
        leastTimePreference = 1
        leastChangesPreference = 0
    }

    override func viewDidLoad() {
        titleLabel.text = Placeholder.Title.RouteTypePreference
        self.view.backgroundColor = UIColor(hexString: Style.ColorPallete.GREY)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if  segue.identifier == "allPreferencesSetSegue"{
            setPreferencesRequest()
        }
    }
    
    func setPreferencesRequest() {
        let spinnerFrame: UIView = self.view.startASpinner()
        let loggedInUser = Helper.getLoggedInUser()
        var routeTypePreference: [String] = [RouteTypePreference.LeastChanges, RouteTypePreference.LeastTime]
        routeTypePreference[leastTimePreference] = RouteTypePreference.LeastTime
        routeTypePreference[leastChangesPreference] = RouteTypePreference.LeastChanges
        let parameters = [API.SetPreferenceEndpoint.Parameter.Id: loggedInUser.id,
                          API.SetPreferenceEndpoint.Parameter.TravelModePreference: transportationModePreference,
                          API.SetPreferenceEndpoint.Parameter.RouteTypePreference: routeTypePreference]
        Alamofire.request(
            .POST,
            API.SetPreferenceEndpoint.Path,
            parameters: (parameters as! [String : AnyObject]),
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
                        self.processSuccessfulResponse(responseJSON, user: loggedInUser, routeTypePreference: routeTypePreference)
                    } else {
                        Helper.alertRequestError(responseJSON, viewController: self)
                    }
                case .Failure(let error):
                    self.alert("Fatal Error", message: "Request failed with error: \(error)", buttonText: "OK")
                }
        }
    }
    
    func processSuccessfulResponse(responseJSON: NSDictionary, user: User, routeTypePreference: [String]) {
        user.routeTypePreference = routeTypePreference
        user.travelModePreference = transportationModePreference
        Helper.updateUser(user)
    }
}
