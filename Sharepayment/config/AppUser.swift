//
//  AppUser.swift
//  Sharepayment
//
//  Created by Sunkanmi Akintoye Ola on 10/27/16.
//  Copyright © 2016 Ola. All rights reserved.
//

import Foundation
class AppUser {
    
    static func createDefaults (_ user: User, authToken: AuthToken) {
        //Set NSUserDefaults values
        Defaults["Access-Token"] = authToken.accessToken
        Defaults["Client"] = authToken.client
        Defaults["Etag"] = authToken.etag
        Defaults["Expiry"] = authToken.expiry
        Defaults["Token-Type"] = authToken.tokenType
        Defaults["Uid"] = authToken.uid
        Defaults["email"] = user.email
        Defaults["name"] = user.name
        Defaults["id"] = user.id
    }
    
    static var id: String {
        return Defaults["id"].stringValue
    }
    
    static var name: String {
        return Defaults["name"].stringValue
    }
    
    static var email: String {
        return Defaults["email"].stringValue
    }
    
    static func logout() {
        Defaults.remove("Access-Token")
        Defaults.remove("Client")
        Defaults.remove("Etag")
        Defaults.remove("Expiry")
        Defaults.remove("Token-Type")
        Defaults.remove("Uid")
        Defaults.remove("name")
        Defaults.remove("email")
        Defaults.remove("id")
        
    }
}
