//
//  User.swift
//  RouteMe
//
//  Created by Hesham Massoud on 21/05/16.
//  Copyright © 2016 Hesham Massoud. All rights reserved.
//

import Foundation

class User {
    var id: String
    var username: String
    var email: String
    
    init(id: String, username: String, email: String) {
        self.id = id
        self.username = username
        self.email = email
    }
    
}