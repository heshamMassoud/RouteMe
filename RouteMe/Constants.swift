//
//  Constants.swift
//  RouteMe
//
//  Created by Hesham Massoud on 25/05/16.
//  Copyright © 2016 Hesham Massoud. All rights reserved.
//

import Foundation
import UIKit

struct Key {
    struct RouteStep {
        static let TransportationMode = "transportationMode"
        struct Transit {
            static let TransportationMode = "transportationMode"
        }
        struct NonTransit {
            static let Distance = "distance"
            static let HTMLInstruction = "htmlIntruction"
        }
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

struct Path {
    
}

struct Style {
    struct Font {
        static let RouteDetailCells = UIFont(name: "HelveticaNeue-Thin", size: 15)!
    }
    struct Height {
        static let RouteDetailCells: CGFloat = 100.0
        static let RouteDetailMapView: CGFloat = 200
        static let LikeSectionVerticalPadding: CGFloat = 14
    }
    
    struct HTML {
        static let InstructionBoldTagOpenning = "<b>"
        static let InstructionBoldTagClosing = "</b>"
        static let InstructionBoldSpanTagOpenning = "<span style='font-family: HelveticaNeue-Light !important; font-size: 15px'>"
        static let InstructionSpanTagOpenning = "<span style='font-family: HelveticaNeue-Thin !important; font-size: 15px'>"
        static let InstructionSpanTagClosing = "</span>"
    }
}

struct Placeholder {
    struct Title {
        static let RouteDetails = "Route details"
    }
}