//
//  User.swift
//  RouteMe
//
//  Created by Hesham Massoud on 21/05/16.
//  Copyright © 2016 Hesham Massoud. All rights reserved.
//

import Foundation

class User: NSObject, NSCoding {
    var id: String
    var username: String
    var email: String
    var travelModePreference: [String] = []
    var routeTypePreference: [String] = ["leastChanges","leastTime"]
    
    init(id: String, username: String, email: String, travelModePreference: [String], routeTypePreference: [String]) {
        self.id = id
        self.username = username
        self.email = email
        self.travelModePreference = travelModePreference
        self.routeTypePreference = routeTypePreference
    }
    
    override init() {
        self.id = ""
        self.username = ""
        self.email = ""
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeObjectForKey("id") as! String
        let username = aDecoder.decodeObjectForKey("username") as! String
        let email = aDecoder.decodeObjectForKey("email") as! String
        let travelModePreference = aDecoder.decodeObjectForKey("travelModePreference") as! [String]
        let routeTypePreference = aDecoder.decodeObjectForKey("routeTypePreference") as! [String]
        self.init(id: id, username: username, email: email, travelModePreference: travelModePreference, routeTypePreference: routeTypePreference)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(id, forKey: "id")
        aCoder.encodeObject(username, forKey: "username")
        aCoder.encodeObject(email, forKey: "email")
        aCoder.encodeObject(travelModePreference, forKey: "travelModePreference")
        aCoder.encodeObject(routeTypePreference, forKey: "routeTypePreference")
        
    }
}