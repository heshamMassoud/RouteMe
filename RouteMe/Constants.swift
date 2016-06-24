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
    //static let Path = "http://routeme-api.us-east-1.elasticbeanstalk.com/api/"
    static let Path = "http://192.168.2.4:9000/api/"
    //static let Path = "http://131.159.197.96:9000/api/"
    struct SearchEndpoint {
        static let Path = "\(API.Path)search"
        struct Parameter {
            static let StartPoint = "startPoint"
            static let EndPoint = "endPoint"
            static let UserId = "userId"
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
            static let HTMLInstruction = "htmlInstruction"
            static let TransportationVehicleShortName = "transportationVehicleShortName"
            static let TransportationLineColorCode = "transportationLineColorCode"
            static let TransportationLineHeadSign = "transportationLineHeadSign"
            static let StartStation = "startStation"
            static let EndStation = "endStation"
            static let Duration = "duration"
            static let StartTime = "startTime"
            static let EndTime = "endTime"
            static let Explanations = "explanations"
            static let StartLocationLat = "startLocationLat"
            static let StartLocationLng = "startLocationLng"
            static let EndLocationLat = "endLocationLat"
            static let EndLocationLng = "endLocationLng"
            static let Liked = "liked"
        }
        
        struct Response {
            static let Ok = 200
        }
    }
    struct UserEndpoint {
        static let Path = "\(API.Path)users/"
        struct Parameter {
            static let Username = "username"
            static let Email = "email"
            static let Password = "password"
        }
        struct Key {
            static let Id = "id"
            static let Username = "username"
            static let Email = "email"
            static let Password = "password"
        }
        
        struct Response {
            static let Created = 201
        }
    }
    struct LoginEndpoint {
        static let Path = "\(API.UserEndpoint.Path)login"
        struct Parameter {
            static let Email = "email"
            static let Password = "password"
        }
        struct Key {
            static let Id = "id"
            static let Username = "username"
            static let Email = "email"
            static let Password = "password"
            static let LikedRoutes = "likedRoutes"
            static let TravelModePreference = "travelModePreference"
            static let RouteTypePreference = "routeTypePreference"
        }
        
        struct Response {
            static let Found = 302
        }
    }
    struct SetPreferenceEndpoint {
        static let Path = "\(API.UserEndpoint.Path)setpreference"
        struct Parameter {
            static let Id = "id"
            static let TravelModePreference = "travelModePreference"
            static let RouteTypePreference = "routeTypePreference"
        }
        
        struct Response {
            static let CREATED = 201
        }
    }
    struct LikeRouteEndpoint {
        static let Path = "\(API.UserEndpoint.Path)like"
        struct Parameter {
            static let UserId = "userId"
            static let TargetEntityId = "targetEntityId"
        }
        
        struct Response {
            static let CREATED = 201
        }
    }
    struct DislikeRouteEndpoint {
        static let Path = "\(API.UserEndpoint.Path)dislike"
    }
}

struct Form {
    struct Error {
        static let Email = "Please enter a valid e-mail address"
        static let Password = "Password must be greater than 1 character"
        static let ConfirmationPassword = "Passwords don't match"
    }
    struct Field {
        static let Email = "E-mail"
        static let Password = "Password"
        static let ConfirmationPassword = "Confirmation Password"
    }
    struct AlertButton {
        static let Ok = "Ok"
    }
}

struct GoogleMapsAPI {
    static let APIKey = "AIzaSyCZk6CWRY-2b1rONt5YKnfqchNxa1F7YiQ"
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
    static let RE = "Long distance train"
    static let ICE = "High speed train"
    static let Modes: [String] = [Bus, Ubahn, Tram, Sbahn, Driving, Bicycling, Walking]
    static let ImagePaths: [String: String] = [Walking: "walking.png",
                                               Bus: "bus.png",
                                               Sbahn: "sbahn.png",
                                               Ubahn: "ubahn.png",
                                               Tram: "tram.png",
                                               Driving: "car.png",
                                               Bicycling: "bike.png",
                                               RE: "bahn.png",
                                               ICE: "bahn.png"
                                               ]
}

struct Explanations {
    static let ImagePaths: [String: String] = ["LIKED": "like-icon.png",
                                               "HYBRID_RECOMMENDER": "collab-icon.png",
                                               "POPULARITY": "popular-icon.png",
                                               "LIKES_PREFERENCES": "like-pref-icon.png",
                                               "PREFERENCES": "pref-icon.png",
                                               "HYBRID_RECOMMENDER_LIKED": "collab-icon.png",
                                               "POPULARITY_LIKED": "popular-icon.png"]
    static let text: [String: String] = ["LIKED": "You've shown interest in this route",
                                               "HYBRID_RECOMMENDER": "Users similar to you show interest in this route",
                                               "POPULARITY": "This route is quite popular in the area",
                                               "LIKES_PREFERENCES": "You've shown interest in this route",
                                               "POPULARITY_LIKED": "You've shown interest in this route. It's also quite a popular route",
                                               "HYBRID_RECOMMENDER_LIKED": "You and users similar to you have shown interest in this route",
                                               "PREFERENCES": "This route is ranked here based on your travel preferences"]
}

struct RouteTypePreference {
    static let LeastChanges = "leastChanges"
    static let LeastTime = "leastTime"
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