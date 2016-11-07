//
//  TransfersViewController.swift
//  Sharepayment
//
//  Created by Sunkanmi Akintoye Ola on 10/27/16.
//  Copyright © 2016 Ola. All rights reserved.
//

import UIKit
import Siesta

class TransfersViewController: UITableViewController, ResourceObserver {
    var direction: TransferDirection?
    
    var statusOverlay = ResourceStatusOverlay()
    
    var transfersResource: Resource? {
        didSet {
            // One call to removeObservers() removes both self and statusOverlay as observers of the old resource,
            // since both observers are owned by self (see below).
            oldValue?.removeObservers(ownedBy: self)
            //            oldValue?.cancelLoadIfUnobserved(afterDelay: 0.1)
            // Adding ourselves as an observer triggers an immediate call to resourceChanged().
            transfersResource?.addObserver(self)
                .addObserver(statusOverlay, owner: self)
                .load()
        }
    }
    
    var transfersList: [Payment] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    func resourceChanged(resource: Resource, event: ResourceEvent) {
        if let payments = transfersResource?.typedContent() as [Payment]? {
            transfersList = payments
        }
        else {
            print("Payment not found")
        }
        self.refreshControl?.endRefreshing()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Payments"
        print(direction?.rawValue)
        transfersResource = SPAPI.payment
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.refreshControl?.addTarget(self, action: #selector(self.handleRefresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        transfersResource = SPAPI.payment
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
//        let vc = storyboard?.instantiateViewControllerWithIdentifier("newTransferViewController") as! NewTransferViewController
//        vc.recipient = transfersList[indexPath.row]
//        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return transfersList.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! TransfersCell
        let payment = transfersList[indexPath.row]
        cell.name.text = payment.person
        cell.amount.text = payment.amount
        cell.dateSent.text = payment.date_sent
        cell.reason.text = payment.reason
        cell.avatar.image = UIImage(named: "avatar")
        return cell
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
