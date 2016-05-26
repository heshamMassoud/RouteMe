//
//  Route.swift
//  RouteMe
//
//  Created by Hesham Massoud on 23/05/16.
//  Copyright © 2016 Hesham Massoud. All rights reserved.
//

import Foundation

class Route {
    var id: String
    var summary: String
    var isTransit: Bool
    var steps: [AnyObject]
    var polyline: String
    var startAddress: String
    var endAddress: String
    //var startLatitude: Double
    //var startLongitude: Double
    
    init(id: String, isTransit: Bool, summary: String, steps: [AnyObject], polyline: String, startAddress: String, endAddress: String) {
        self.id = id
        self.summary = summary
        self.isTransit = isTransit
        self.steps = steps
        self.polyline = polyline
        self.startAddress = startAddress
        self.endAddress = endAddress
    }
    
    init() {
        self.id = String()
        self.summary = String()
        self.isTransit = false
        self.steps = []
        self.polyline = String()
        self.startAddress = String()
        self.endAddress = String()
    }
}