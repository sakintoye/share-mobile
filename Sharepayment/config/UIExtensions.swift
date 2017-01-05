//
//  UIExtensions.swift
//  Sharepayment
//
//  Created by Sunkanmi Akintoye Ola on 10/27/16.
//  Copyright © 2016 Ola. All rights reserved.
//

import Foundation
import UIKit
extension UIButton {
    
    func makeGreen() {
        self.design("#006200", textColor: "#ffffff")
    }
    
    func makeBlue() {
        self.design("#1D62F0", textColor: "#ffffff")
    }
    
    func makeRed() {
        self.design("#ff0000", textColor: "#ffffff")
    }
    
    fileprivate func design(_ backgroundColor: String, textColor: String) {
        self.backgroundColor = UIColor(hexString: backgroundColor)
        self.tintColor = UIColor(hexString: textColor)
        self.layer.borderColor = UIColor(hexString: backgroundColor)?.cgColor
        self.layer.borderWidth = 2
        self.layer.cornerRadius = 5
        self.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 110)
    }
}
