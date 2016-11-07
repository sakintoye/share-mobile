//
//  NewTransferViewController.swift
//  Sharepayment
//
//  Created by Sunkanmi Akintoye Ola on 10/27/16.
//  Copyright © 2016 Ola. All rights reserved.
//

import UIKit

class NewTransferViewController: UIViewController {
    
    var recipient: User?

    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var amount: UITextField!
    @IBOutlet weak var actionBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = AppTheme.background
        actionBtn.makeGreen()
        cancelBtn.makeRed()
        if let recipient = self.recipient {
            name.text = recipient.name
        }
        name.textColor = AppTheme.highlightText
        // Do any additional setup after loading the view.
    }

    @IBAction func cancelBtnAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
