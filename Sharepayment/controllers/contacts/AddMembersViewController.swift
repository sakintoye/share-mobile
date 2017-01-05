//
//  AddMembersViewController.swift
//  Sharepayment
//
//  Created by Sunkanmi Akintoye Ola on 11/2/16.
//  Copyright © 2016 Ola. All rights reserved.
//

import UIKit
import Siesta
import SwiftyJSON
import ZAlertView

class AddMembersViewController: UITableViewController, ResourceObserver {

    override func viewDidLoad() {
        super.viewDidLoad()

        membersResource = SPAPI.member
        
        self.refreshControl?.addTarget(self, action: #selector(self.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Close", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.closeView(_:)))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var statusOverlay = ResourceStatusOverlay()
    
    var membersResource: Resource? {
        didSet {
            // One call to removeObservers() removes both self and statusOverlay as observers of the old resource,
            // since both observers are owned by self (see below).
            oldValue?.removeObservers(ownedBy: self)
            //            oldValue?.cancelLoadIfUnobserved(afterDelay: 0.1)
            // Adding ourselves as an observer triggers an immediate call to resourceChanged().
            membersResource?.addObserver(self)
                .addObserver(statusOverlay, owner: self)
                .load()
        }
    }
    
    var membersList: [User] = [] {
        didSet {
            
            tableView.reloadData()
        }
    }
    
    func resourceChanged(_ resource: Resource, event: ResourceEvent) {
        if let members = membersResource?.typedContent() as [User]? {
            membersList = members
        }
        else {
            print("Members not found")
        }
        self.refreshControl?.endRefreshing()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let member = self.membersList[indexPath.row]
        let contact = ["contact": ["contact_id": member.id!]]  as NSDictionary
        SPAPI.contact
        .request(.POST, json: contact)
        .onSuccess { (data) in
            self.showSuccessAlert()
            self.dismiss(animated: true, completion: nil)
        }
        .onFailure { (error) in
            self.showErrorAlert("Action unsuccessful", message: "Could not complete the operation")
            print("Error while trying to add member")
            print(error)
        }

    }
    
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        membersResource = SPAPI.member
    }
    
    func showSuccessAlert() {
        ZAlertView(title: "Successful", message: "You added a contact!", closeButtonText: "Close") { (view) in
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return membersList.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellInfo", for: indexPath) as! AddMemberCell
        let contact = membersList[indexPath.row]
        cell.name.text = contact.name
        cell.email.text = contact.email
        cell.photo.image = UIImage(named: "avatar")
        return cell
    }
    
    func closeView(_:UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
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
