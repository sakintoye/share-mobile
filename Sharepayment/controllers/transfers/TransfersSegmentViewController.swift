//
//  TransfersSegmentViewController.swift
//  Sharepayment
//
//  Created by Sunkanmi Akintoye Ola on 10/27/16.
//  Copyright © 2016 Ola. All rights reserved.
//

import UIKit

class TransfersSegmentViewController: UIViewController {

    var currentViewController: UIViewController?
    @IBOutlet weak var controllersHolder: UIView!
    @IBOutlet weak var segments: UISegmentedControl!
    var inboundSegmentVC: TransfersViewController?
    var outboundSegmentVC: TransfersViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.segments.tintColor = AppTheme.background
        self.displayCurrentTab(0)
//        self.segments.backgroundColor = AppTheme.background

        // Do any additional setup after loading the view.
    }
    
    @IBAction func segmentAction(_ sender: AnyObject) {
        self.currentViewController!.view.removeFromSuperview()
        self.currentViewController!.removeFromParentViewController()
        print("Changing view")
        displayCurrentTab(sender.selectedSegmentIndex)
    }
    
    func displayCurrentTab(_ tabIndex: Int){
        if let vc = viewControllerForSelectedSegmentIndex(tabIndex) {
            self.addChildViewController(vc)
            vc.didMove(toParentViewController: self)
            vc.view.frame = self.controllersHolder.bounds
            self.controllersHolder.addSubview(vc.view)
            self.currentViewController = vc
            vc.viewWillAppear(true)
        }
    }
    
    func viewControllerForSelectedSegmentIndex(_ index: Int) -> UIViewController? {
        switch index {
        case 0:
            self.title = "Sent"
            if inboundSegmentVC == nil {
                inboundSegmentVC = storyboard?.instantiateViewController(withIdentifier: "transfersViewController") as? TransfersViewController
            }
            inboundSegmentVC!.direction = TransferDirection.outbound
            return inboundSegmentVC
        case 1:
            self.title = "Received"
            if outboundSegmentVC == nil {
                outboundSegmentVC = storyboard?.instantiateViewController(withIdentifier: "transfersViewController") as? TransfersViewController
            }
            outboundSegmentVC!.direction = TransferDirection.inbound
            return inboundSegmentVC
        default:
            return nil
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
