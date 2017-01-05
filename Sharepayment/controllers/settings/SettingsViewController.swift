//
//  SettingsViewController.swift
//  Sharepayment
//
//  Created by Sunkanmi Akintoye Ola on 10/27/16.
//  Copyright © 2016 Ola. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {

    enum SettingMenuType: String {
        case About = "about"
        case Profile = "editProfile"
        case Teams = "teams"
        case Card = "card"
        case Logout = "logout"
        case OpenSource = "openSource"
        case ToC = "terms"
    }
    
    struct SettingSection {
        var title: String
        var items: [SettingMenuItem]
        var description: String
    }
    
    struct SettingMenuItem {
        var name: String
        var type: SettingMenuType
        var tag: String
        var enabled: Bool
        var show: Bool
        
    }
    
    fileprivate struct Tags {
        struct UserProfile {
            static let Info = "info"
            static let Categories = "categories"
        }
        
        struct Teams {
            static let Invite = "invite"
        }
        
        struct Subscription {
            static let Manage = "manageSubscription"
        }
        
        struct AboutApp {
            static let About = "about"
            static let Privacy = "privacy"
            static let ToC = "toc"
        }
        
        struct LogOut {
            static let LogOut = "logout"
        }
    }
    
    var profileSection: [SettingMenuItem] = [
        SettingMenuItem(name: "Profile", type: .Profile, tag: Tags.UserProfile.Info, enabled: true, show: true)
    ]
    
    let teamsSection: [SettingMenuItem] = [
        SettingMenuItem(name: "Invite", type: .Teams, tag: Tags.Teams.Invite, enabled: true, show: true)
    ]
    
    let cardSection: [SettingMenuItem] = [
        SettingMenuItem(name: "My Cards", type: .Card, tag: Tags.Subscription.Manage, enabled: true, show: true)
    ]
    
    let aboutSection: [SettingMenuItem] = [
        SettingMenuItem(name: "About", type: .About, tag: Tags.AboutApp.About, enabled: true, show: true),
        SettingMenuItem(name: "Terms and Conditions", type: .ToC, tag: Tags.AboutApp.ToC, enabled: true, show: true)
    ]
    
    let logOutSection: [SettingMenuItem] = [
        SettingMenuItem(name: "Log out", type: .Logout, tag: Tags.LogOut.LogOut, enabled: true, show: true)
    ]
    
    var sections: [SettingSection] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Settings"
        
        sections.append(SettingSection(title: "My Profile", items: profileSection, description: ""))
//        sections.append(SettingSection(title: "Invitations", items: teamsSection, description: "Invite team members and control access"))
        sections.append(SettingSection(title: "My Cards", items: cardSection, description: "Manage your cards"))
        
        sections.append(SettingSection(title: "About \(AppConfig.name)", items: aboutSection, description: ""))
        sections.append(SettingSection(title: "", items: logOutSection, description: ""))
        
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = self.sections[section]
        return sectionInfo.items.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = self.sections[indexPath.section].items[indexPath.row]
        tableView.cellForRow(at: indexPath)?.setSelected(false, animated: true)
        switch row.type {
        case .About:
            showAboutView()
            break
        case .Card:
            showSubscriptionView(row)
        case .Logout:
            doLogOut()
            break
        case .Profile:
            showUserProfileView()
            break
        default:
            print("Hello")
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        let row = self.sections[indexPath.section].items[indexPath.row]
        
        cell.textLabel?.text = row.name
        cell.accessoryType = .disclosureIndicator
        if row.type == .Logout {
            cell.accessoryType = .none
            cell.textLabel?.textColor = UIColor.red
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionInfo = self.sections[section]
        return sectionInfo.title
    }
    
    func doLogOut() {
        let alertController = UIAlertController(title: AppUser.name, message: "Do you want to sign out of \(AppConfig.name)?", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: {(alert :UIAlertAction!) in
            //DO nothing
        })
        alertController.addAction(cancelAction)
        
        let okAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: {(alert :UIAlertAction!) in
            //Sign out user
            self.logUserOut()
        })
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func logUserOut() {
        AppUser.logout()
        let vc = storyboard!.instantiateViewController(withIdentifier: "loginViewController")
        self.present(vc, animated: true, completion: nil)
    }
    
    func showAboutView() {
//        let vc = storyboard!.instantiateViewControllerWithIdentifier("aboutAppVC")
//        vc.title = AppConfig.name
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showUserProfileView() {
//        let vc = storyboard!.instantiateViewControllerWithIdentifier("userProfileVC")
//        vc.title = "Profile"
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showSubscriptionView(_ row: SettingMenuItem) {
        switch row.tag {
        case Tags.Subscription.Manage:
//            let vc = storyboard!.instantiateViewControllerWithIdentifier("stripeStepOneVC") as! StripeStepOneVC
//            self.navigationController?.pushViewController(vc, animated: true)
            break
        default:
            break
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
