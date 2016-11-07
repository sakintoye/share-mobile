//
//  User.swift
//  Sharepayment
//
//  Created by Sunkanmi Akintoye Ola on 10/27/16.
//  Copyright © 2016 Ola. All rights reserved.
//
import Foundation
import SwiftyJSON

struct User {
    let id: Int?
    let email: String?
    let name: String?
    
    init(json: JSON) {
        id      = json["id"].intValue
        email   = json["email"].stringValue
        name    = json["name"].stringValue.capitalizedString
        print(json)
    }
}