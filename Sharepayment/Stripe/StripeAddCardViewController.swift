//
//  CheckoutViewController.swift
//  Stripe iOS Example (Simple)
//
//  Created by Ben Guo on 4/22/16.
//  Copyright © 2016 Stripe. All rights reserved.
//
import UIKit
import Stripe

class StripeAddCardViewController: UIViewController, STPAddCardViewControllerDelegate {
    
    var subscriptionPlan: String = ""
    var customerID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.getCustomerID()
        print(customerID!)
        self.showStripeCardView()
    }
    
    // MARK: STPAddCardViewControllerDelegate
    
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreateToken token: STPToken, completion: @escaping STPErrorBlock) {
        let stripeAdapter = StripeAPIClient()
        stripeAdapter.customerID = self.customerID! //"cus_90mxjcaQV6yGeJ"
        stripeAdapter.attachSource(toCustomer: token) { (error: NSError?) in
            if let _ = error {
                completion(error)
                //Error
                print(error)
            } else {
               self.closeViewController()
            }
        }
    }
    @IBAction func addCardAction(_ sender: AnyObject) {
        self.showStripeCardView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showStripeCardView() {
        STPPaymentConfiguration.shared().smsAutofillDisabled = true
        
        let addCardViewController = STPAddCardViewController()
        addCardViewController.delegate = self
        
        let paymentContext = STPPaymentContext(apiAdapter: StripeAPIClient.sharedClient)
        let userInformation = STPUserInformation()
        paymentContext.prefilledInformation = userInformation
        
        paymentContext.hostViewController = self
        
        self.navigationController?.pushViewController(addCardViewController, animated: true)
    }
    
    func closeViewController() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "userTab")
//        let nc = UINavigationController(rootViewController: vc!)
        self.present(vc!, animated: true, completion: nil)
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
