//
//  LoginViewController.swift
//  Sharepayment
//
//  Created by Sunkanmi Akintoye Ola on 10/12/16.
//  Copyright © 2016 Ola. All rights reserved.
//

import UIKit
import Siesta
import SwiftyJSON

class LoginViewController: UIViewController, ResourceObserver {
    
    var statusOverlay = ResourceStatusOverlay()
    
    
    @IBOutlet weak var appName: UILabel!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var signInBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.appName.text = AppConfig.name
        self.appName.textColor = UIColor(hexString: "4B4B4B")
        self.view.backgroundColor = AppTheme.greyBackground
        self.emailText.text = "sakintoye2015@my.fit.edu"
        self.passwordText.text = "00000000"
        self.signInBtn.makeGreen()
        
        
    }
    @IBAction func loginBtnAction(sender: AnyObject) {
        
        self.login()
    }
    
    func login() {
        do {
        SPAPI.logIn(self.emailText.text!, password: self.passwordText.text!)
        .onSuccess { (data) in
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
            self.userResource = SPAPI.me
            
        }
        .onFailure { (error) in
            print("Error while trying to login")
            print("See trace below")
            print(error)
        }
        }
    }
    
    var userResource: Resource? {
        didSet {
            // One call to removeObservers() removes both self and statusOverlay as observers of the old resource,
            // since both observers are owned by self (see below).
            oldValue?.removeObservers(ownedBy: self)
//            oldValue?.cancelLoadIfUnobserved(afterDelay: 0.1)
            // Adding ourselves as an observer triggers an immediate call to resourceChanged().
            userResource?.addObserver(self)
                .addObserver(statusOverlay, owner: self)
                .load()
        }
    }
    
    func resourceChanged(resource: Resource, event: ResourceEvent) {
        // The convenience .jsonDict accessor returns empty dict if no
        // data, so the same code can both populate and clear fields.
        //let json = resource.jsonDict
        showHomeTab(userResource?.typedContent())
    }
    
    func showHomeTab(user: User?) {
        if let userInfo = user {
            let vc = storyboard?.instantiateViewControllerWithIdentifier("userTab")
            self.presentViewController(vc!, animated: true, completion: nil)
        }
        else {
            print("Not available")
        }
    }
    @IBAction func signUpBtnAction(sender: AnyObject) {
        let vc = storyboard?.instantiateViewControllerWithIdentifier("signUpViewController") as? SignUpViewController
        self.presentViewController(vc!, animated: true, completion: nil)
        
//        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("stripeAddCardViewController") as! StripeAddCardViewController
//        let nc = UINavigationController(rootViewController: vc)
//        self.presentViewController(nc, animated: true, completion: nil)
        
//        SPAPI.resource("stripe/customer")
//            .request(.POST, json: ["fullname": "Ola Akintoye", "email": "ola2@akintoye.me"])
//            .onSuccess({ (data) in
//                let user = data.content as! JSON
//                print(user["id"].stringValue)
//            })
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
