//
//  Payment.swift
//  Sharepayment
//
//  Created by Sunkanmi Akintoye Ola on 10/25/16.
//  Copyright © 2016 Ola. All rights reserved.
//

import Foundation
import SwiftyJSON
class Payment {
    
    let id: Int?
    let recipient_id: Int?
    let amount: String?
    let sender_id: Int?
    let person: String?
    let reason: String?
    let status: String?
    let date_sent: String?
    
    init(json: JSON) {
        id = json["id"].intValue
        recipient_id = json["recipient_id"].intValue
        sender_id = json["sender_id"].intValue
        amount = json["amount"].stringValue
        reason = json["reason"].stringValue
        status = json["status"].stringValue
        date_sent = json["date_sent"].stringValue
        person = json["name"].stringValue.capitalizedString
    }
    
    
}


//"id": 2,
//"recipient_id": 3,
//"sender_id": 1,
//"amount": "20.0",
//"reason": "Drinks",
//"status": "pending",
//"date_sent": "2016-10-01T03:00:00.000Z",
//"name": "Sunky"