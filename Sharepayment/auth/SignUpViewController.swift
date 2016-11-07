//
//  SignUpViewController.swift
//  Sharepayment
//
//  Created by Sunkanmi Akintoye Ola on 11/1/16.
//  Copyright © 2016 Ola. All rights reserved.
//

import UIKit
import SwiftyJSON

class SignUpViewController: UIViewController {

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirm_password: UITextField!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var errorText: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.errorText.text = ""
        signUpBtn.makeGreen()
        self.view.backgroundColor = AppTheme.greyBackground
        // Do any additional setup after loading the view.
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.DismissKeyboard))
        view.addGestureRecognizer(tap)
        self.name.text = "Sunkanmi Akintoye"
        self.email.text = "777"
        self.password.text = "333"
        self.confirm_password.text = "333"
    }

    @IBAction func closeBtnAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func signUpAction(sender: AnyObject) {
        if self.email.text != "" && self.name.text != "" {
            if self.password.text != "" && self.password.text == self.confirm_password.text {
                SPAPI.signUp(self.name.text!, email: self.email.text!, password: self.password.text!, confirm_password: self.confirm_password.text!)
                .onSuccess({ (data) in
                    let authToken = AuthToken()
                    authToken.accessToken = data.header("Access-Token")
                    authToken.client = data.header("Client")
                    authToken.etag = data.header("Etag")
                    authToken.expiry = data.header("Expiry")
                    authToken.tokenType = data.header("Token-Type")
                    authToken.uid = data.header("Uid")
                    
                    let user = User(json: (data.content as? JSON)!["data"])
                    AppUser.createDefaults(user, authToken: authToken)
                    
                    SPAPI.authToken = authToken
                    
                    SPAPI.resource("stripe/customer")
                    .request(.POST, json: ["fullname": "\(user.name!)", "email": "\(user.email!)"])
                    .onSuccess({ (data) in
                        let user = data.content as! JSON
                        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("stripeAddCardViewController") as! StripeAddCardViewController
                        vc.customerID = user["id"].stringValue
                        let nc = UINavigationController(rootViewController: vc)
                        self.presentViewController(nc, animated: true, completion: nil)

                    })
                    
                    
                })
                .onFailure({ (error) in
                    
                    var message = "Unknown Error"
                    if let errors = error.jsonDict["errors"]!["full_messages"] as? NSArray {
                        message = errors.firstObject as! String
                    }

                    let errorAlert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.Alert)
                    errorAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(errorAlert, animated: true, completion: nil)
                })
            }
            else {
                self.errorText.text = "Passwords don't match"
            }
        }
        else {
            self.errorText.text = "Email is required"
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
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
