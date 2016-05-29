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
                var transportationMode = ""
                var transportationLineHeadSign = ""
                var transportationVehicleShortName = ""
                var transportationLineColorCode = ""
                var startStation = ""
                var endStation = ""
                var duration = ""
                var startTime = ""
                var endTime = ""
                if let transportationModeUW = step[API.SearchEndpoint.Key.TransportationMode] as? String{
                    transportationMode = transportationModeUW
                }
                if let transportationLineHeadSignUW = step[API.SearchEndpoint.Key.TransportationLineHeadSign] as? String{
                    transportationLineHeadSign = transportationLineHeadSignUW
                }
                if let transportationVehicleShortNameUW = step[API.SearchEndpoint.Key.TransportationVehicleShortName] as? String{
                    transportationVehicleShortName = transportationVehicleShortNameUW
                }
                if let transportationLineColorCodeUW = step[API.SearchEndpoint.Key.TransportationLineColorCode] as? String{
                    transportationLineColorCode = transportationLineColorCodeUW
                }
                if let startStationUW = step[API.SearchEndpoint.Key.StartStation] as? String{
                    startStation = startStationUW
                }
                if let endStationUW = step[API.SearchEndpoint.Key.EndStation] as? String{
                    endStation = endStationUW
                }
                if let durationUW = step[API.SearchEndpoint.Key.Duration] as? String{
                    duration = durationUW
                }
                if let startTimeUW = step[API.SearchEndpoint.Key.StartTime] as? String{
                    startTime = startTimeUW
                }
                if let endTimeUW = step[API.SearchEndpoint.Key.EndTime] as? String{
                    endTime = endTimeUW
                }
                let transitStep = TransitStep(transportationMode: transportationMode,
                                              transportationLineHeadSign: transportationLineHeadSign,
                                              transportationVehicleShortName: transportationVehicleShortName,
                                              transportationLineColorCode: transportationLineColorCode,
                                              startStation: startStation,
                                              endStation: endStation,
                                              duration: duration,
                                              startTime: startTime,
                                              endTime: endTime)
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