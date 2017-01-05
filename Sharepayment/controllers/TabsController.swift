//
//  TabsController.swift
//  Sharepayment
//
//  Created by Sunkanmi Akintoye Ola on 10/27/16.
//  Copyright © 2016 Ola. All rights reserved.
//

import UIKit

class TabsController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UITabBar.appearance().tintColor = UIColor(hexString: "#007600")
        let numberOfItems = CGFloat(tabBar.items!.count)
        let tabBarItemSize = CGSize(width: tabBar.frame.width / numberOfItems, height: tabBar.frame.height)
        tabBar.selectionIndicatorImage = UIImage.imageWithColor(UIColor(hexString: "#b1ffb1")!, size: tabBarItemSize).resizableImage(withCapInsets: UIEdgeInsets.zero)
        
        
        // remove default border
        tabBar.frame.size.width = self.view.frame.width + 4
        tabBar.frame.origin.x = -2
        
        UITabBar.appearance().backgroundColor = UIColor(hexString: "#DADADA")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //        if let items = self.tabBar.items {
        //            for item in items {
        //                let unselectedItem = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        //                let selectedItem = [NSForegroundColorAttributeName: UIColor.purpleColor()]
        //
        ////                item.setTitleTextAttributes(unselectedItem, forState: .Normal)
        //                item.setTitleTextAttributes(selectedItem, forState: .Selected)
        //            }
        //        }
    }
}

extension UIImage {
    class func imageWithColor(_ color: UIColor, size: CGSize) -> UIImage {
        let rect: CGRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
}
