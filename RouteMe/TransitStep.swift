//
//  TransitStep.swift
//  RouteMe
//
//  Created by Hesham Massoud on 27/05/16.
//  Copyright © 2016 Hesham Massoud. All rights reserved.
//

import Foundation

class TransitStep {
    var transportationMode: String
    var transportationLineHeadSign: String
    var transportationVehicleShortName: String
    var transportationLineColorCode: String
    var startStation: String
    var endStation: String
    var duration: String
    var startTime: String
    var endTime: String
    
    
    init(transportationMode: String, transportationLineHeadSign: String, transportationVehicleShortName: String, transportationLineColorCode: String, startStation: String, endStation: String, duration: String, startTime: String, endTime: String) {
        self.transportationMode = transportationMode
        self.transportationLineHeadSign = transportationLineHeadSign
        self.transportationVehicleShortName = transportationVehicleShortName
        self.transportationLineColorCode = transportationLineColorCode
        self.startStation = startStation
        self.endStation = endStation
        self.duration = duration
        self.startTime = startTime
        self.endTime = endTime
    }
    
    init() {
        self.transportationMode = String()
        self.transportationLineHeadSign = String()
        self.transportationVehicleShortName = String()
        self.transportationLineColorCode = String()
        self.startStation = String()
        self.endStation = String()
        self.duration = String()
        self.startTime = String()
        self.endTime = String()
    }
}