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
    // New attributes
    var startLatitude: Double
    var startLongitude: Double
    var endLatitude: Double
    var endLongitude: Double
    var transitSteps: [TransitStep]
    var liked: Bool
    var explanation: String
    
    init(id: String, isTransit: Bool, summary: String, steps: [AnyObject], polyline: String, startAddress: String, endAddress: String, startLatitude: Double,
        startLongitude: Double, endLatitude: Double, endLongitude: Double, liked: Bool, explanation: String) {
        self.id = id
        self.summary = summary
        self.isTransit = isTransit
        self.steps = steps
        self.polyline = polyline
        self.startAddress = startAddress
        self.endAddress = endAddress
        self.startLatitude = startLatitude
        self.endLatitude = endLatitude
        self.startLongitude = startLongitude
        self.endLongitude = endLongitude
        self.transitSteps = []
        self.liked = liked
        self.explanation = explanation
        if isTransit {
            for step in steps {
                let transitStep = TransitStep(transportationMode: step[API.SearchEndpoint.Key.TransportationMode] as! String,
                                              transportationLineHeadSign: step[API.SearchEndpoint.Key.TransportationLineHeadSign] as! String,
                                              transportationVehicleShortName: step[API.SearchEndpoint.Key.TransportationVehicleShortName] as! String,
                                              transportationLineColorCode: step[API.SearchEndpoint.Key.TransportationLineColorCode] as! String,
                                              startStation: step[API.SearchEndpoint.Key.StartStation] as! String,
                                              endStation: step[API.SearchEndpoint.Key.EndStation] as! String,
                                              duration: step[API.SearchEndpoint.Key.Duration] as! String,
                                              startTime: step[API.SearchEndpoint.Key.StartTime] as! String,
                                              endTime: step[API.SearchEndpoint.Key.EndTime] as! String)
                self.transitSteps.append(transitStep)
            }
        }
    }
    
    init() {
        self.id = String()
        self.summary = String()
        self.isTransit = false
        self.steps = []
        self.polyline = String()
        self.startAddress = String()
        self.endAddress = String()
        self.startLatitude = 0
        self.endLatitude = 0
        self.startLongitude = 0
        self.endLongitude = 0
        self.transitSteps = []
        self.liked = false
        self.explanation = String()
    }
}