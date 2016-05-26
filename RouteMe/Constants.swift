//
//  Constants.swift
//  RouteMe
//
//  Created by Hesham Massoud on 25/05/16.
//  Copyright © 2016 Hesham Massoud. All rights reserved.
//

import Foundation
import UIKit

struct API {
    struct SearchEndpoint {
        static let Path = "http://routeme-api.us-east-1.elasticbeanstalk.com/api/search"
        struct Parameter {
            static let StartPoint = "startPoint"
            static let EndPoint = "endPoint"
        }
        struct Key {
            static let RouteResults = "routeResults"
            static let PredictionIoId = "predictionIoId"
            static let IsTransit = "transit"
            static let Summary = "routeSummary"
            static let Steps = "steps"
            static let Polyline = "overviewPolyLine"
            static let StartAddress = "startAddress"
            static let EndAddress = "endAddress"
            static let TransportationMode = "transportationMode"
            static let Distance = "distance"
            static let HTMLInstruction = "htmlIntruction"
            static let TransportationVehicleShortName = "transportationVehicleShortName"
            static let TransportationLineColorCode = "transportationLineColorCode"
        }
        
        struct Response {
            static let Ok = 200
        }
    }
}

struct GoogleMapsAPI {
    struct Autocomplete {
        static let BiasCountry = "de"
    }
}

struct Transportation {
    static let Bus = "Bus"
    static let Ubahn = "U-bahn"
    static let Tram = "Tram"
    static let Sbahn = "S-bahn"
    static let Driving = "DRIVING"
    static let Bicycling = "BICYCLING"
    static let Walking = "WALKING"
    static let Modes: [String] = [Bus, Ubahn, Tram, Sbahn, Driving, Bicycling, Walking]
    static let ImagePaths: [String: String] = [Walking: "walking.png",
                                               Bus: "bus.png",
                                               Sbahn: "sbahn.png",
                                               Ubahn: "ubahn.png",
                                               Tram: "tram.png",
                                               Driving: "car.png",
                                               Bicycling: "bike.png"]
}

struct Image {
    struct Background {
        static let Signup = "seat_routeme.JPG"
        static let Home = "bus_routeme.jpeg"
        static let Login = "city_routeme.jpg"
    }
    
}

struct Style {
    struct Font {
        static let RouteDetailCells = UIFont(name: "HelveticaNeue-Thin", size: 15)!
        static let AutocompleteResults = UIFont(name: "HelveticaNeue-Thin", size: 20)!
    }
    struct Height {
        static let RouteDetailCells: CGFloat = 100.0
        static let RouteDetailMapView: CGFloat = 200
        static let LikeSectionVerticalPadding: CGFloat = 14
        static let RouteSearchResultsCells: CGFloat = 100.0
    }
    
    struct HTML {
        static let InstructionBoldTagOpenning = "<b>"
        static let InstructionBoldTagClosing = "</b>"
        static let InstructionBoldSpanTagOpenning = "<span style='font-family: HelveticaNeue-Light !important; font-size: 15px'>"
        static let InstructionSpanTagOpenning = "<span style='font-family: HelveticaNeue-Thin !important; font-size: 15px'>"
        static let InstructionSpanTagClosing = "</span>"
    }
    
    struct ColorPallete {
        static let Blue = "#4F5D73"
        static let Yellow = "#F5CF87"
        static let RED = "#C75C5C"
        static let GREY = "#E0E0D1"
    }
}

struct Placeholder {
    struct Title {
        static let RouteDetails = "Route details"
        static let RouteTypePreference = "Please choose your route type preference"
    }
}