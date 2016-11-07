//
//  ContactsViewController.swift
//  Sharepayment
//
//  Created by Sunkanmi Akintoye Ola on 10/27/16.
//  Copyright © 2016 Ola. All rights reserved.
//

import UIKit
import Siesta

class ContactsViewController: UITableViewController, ResourceObserver {
    
    var statusOverlay = ResourceStatusOverlay()
    
    var contactsResource: Resource? {
        didSet {
            // One call to removeObservers() removes both self and statusOverlay as observers of the old resource,
            // since both observers are owned by self (see below).
            oldValue?.removeObservers(ownedBy: self)
            //            oldValue?.cancelLoadIfUnobserved(afterDelay: 0.1)
            // Adding ourselves as an observer triggers an immediate call to resourceChanged().
            contactsResource?.addObserver(self)
                .addObserver(statusOverlay, owner: self)
                .load()
        }
    }
    
    var contactsList: [User] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Contacts"
        self.navigationItem.leftBarButtonItem = nil // UIBarButtonItem(title: "Left Button", style:   UIBarButtonItemStyle.Plain, target: self, action: nil)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add Contact", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(self.showMembers(_:)))
        
        contactsResource = SPAPI.contact
        
        self.refreshControl?.addTarget(self, action: #selector(self.handleRefresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    override func viewDidAppear(animated: Bool) {
        contactsResource = SPAPI.contact
    }
    
    func resourceChanged(resource: Resource, event: ResourceEvent) {
        if let contacts = contactsResource?.typedContent() as [User]? {
            contactsList = contacts
        }
        else {
            print("Contact not found")
        }
        self.refreshControl?.endRefreshing()
    }

    
    
    func showMembers(_:UIBarButtonItem) {
        let vc = storyboard?.instantiateViewControllerWithIdentifier("addMembersViewController") as! AddMembersViewController
        let nc = UINavigationController(rootViewController: vc)
        self.presentViewController(nc, animated: true, completion: nil)
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        contactsResource = SPAPI.contact
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.cellForRowAtIndexPath(indexPath)?.setSelected(false, animated: true)
        let vc = storyboard?.instantiateViewControllerWithIdentifier("newTransferViewController") as! NewTransferViewController
        vc.recipient = contactsList[indexPath.row]
        self.presentViewController(vc, animated: true, completion: nil)
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return contactsList.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellInfo", forIndexPath: indexPath) as! ContactsCell
        let contact = contactsList[indexPath.row]
        cell.name.text = contact.name
        cell.userPhoto.image = UIImage(named: "avatar")
        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
