//
//  NewTransferViewController.swift
//  Sharepayment
//
//  Created by Sunkanmi Akintoye Ola on 10/27/16.
//  Copyright © 2016 Ola. All rights reserved.
//

import UIKit
import Stripe
import ZAlertView
//import PopupDialog

class NewTransferViewController: UIViewController {
    
    var recipient: User?

    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var amount: UITextField!
    @IBOutlet weak var actionBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    var paymentContext: STPPaymentContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = AppTheme.background
        actionBtn.makeGreen()
        cancelBtn.makeRed()
        if let recipient = self.recipient {
            name.text = recipient.name
        }
        name.textColor = AppTheme.highlightText
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.DismissKeyboard))
        view.addGestureRecognizer(tap)
        
        //self.paymentContext.pushPaymentMethodsViewController()
    }
    
    @IBAction func makeTransferBtn(_ sender: AnyObject) {
        let id = "card_19E0dBL8zrCITgxE2w0GrqxD"
        let brand = STPCardBrand.visa
        let last4 = "4242"
        let funding = STPCardFundingType.credit
        let card = STPCard(id: id, brand: brand, last4: last4, expMonth: 2, expYear: 2017, funding: funding)
        
        card.number = "4242424242424242"
        Stripe.createToken(with: card) { (token, error) in
            if let error = error {
                // show the error to the user
                print(error)
            } else if let token = token {
                self.startAnimation()
                let stripeClient = StripeAPIClient()
                stripeClient.customerID = "cus_9X4mPfNerDvEaJ"
                stripeClient.completeCharge(token, amount: Double(self.amount.text!)!, recipient_id: self.recipient!.id!, completion: { (error) in
                    if error == nil {
                        SPAPI.payment
                        .request(.POST, json: ["payment": ["recipient_id": self.recipient!.id!, "amount": self.amount.text!, "reason": "Testing"] ])
                        .onSuccess({ (data) in
                            self.showSuccessAlert()
                        })
                        .onFailure({ (data) in
                            self.showErrorAlert("Failed", message: "Could not submit payment. \n Please try again")
                        })
                    }
                    else {
                        self.showErrorAlert("Failed", message: "Could not charge account")
                    }
                })
            }
        }
    }
    
    func showSuccessAlert() {
        ZAlertView(title: "Successful", message: "Paymnet was successful", closeButtonText: "Close") { (view) in
            view.dismiss()
            self.dismiss(animated: true, completion: nil)
        }
        .show()
    }
    
    func showErrorAlert(_ title: String, message: String) {
        
        let alert = ZAlertView(title: title, message: message, closeButtonText: "Close") { (view) in
            view.dismiss()
            }
        alert.alertType = ZAlertView.AlertType.alert
        alert.show()
        
    }
    
    func startAnimation() {
        // MARK: -
        let view      = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 568))
        let indicator = MaterialLoadingIndicator(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        indicator.center = CGPoint(x: 320*0.5, y: 568*0.5)
        view.addSubview(indicator)
        indicator.startAnimating()
    }
    
    func confirmDismiss() {
        let refreshAlert = UIAlertController(title: "Cancel Payment", message: "Are you sure you want to cancel this payment?", preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            
        }))
        
        present(refreshAlert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func cancelTransferBtnAction(_ sender: AnyObject) {
        self.confirmDismiss()
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
