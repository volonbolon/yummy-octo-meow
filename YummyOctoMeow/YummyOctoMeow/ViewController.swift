//
//  ViewController.swift
//  YummyOctoMeow
//
//  Created by Ariel Rodriguez on 8/10/15.
//  Copyright (c) 2015 Ariel Rodriguez. All rights reserved.
//

import UIKit
import Accounts

class ViewController: UIViewController {
    var accountStore:ACAccountStore!
    var fbAccount:ACAccount!
    @IBOutlet weak var usernameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.facebookLogin()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func facebookLogin() {
        self.accountStore = ACAccountStore()
        let accountType = self.accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierFacebook)
        let appID = "988286564524796"
        let fbInfo = [ACFacebookAppIdKey:appID, ACFacebookPermissionsKey:["email"], ACFacebookAudienceKey:ACFacebookAudienceEveryone]
        self.accountStore.requestAccessToAccountsWithType(accountType, options: fbInfo as [NSObject:AnyObject]) { (granted:ObjCBool, error:NSError!) -> Void in
            if granted.boolValue == true {
                let accounts = self.accountStore.accountsWithAccountType(accountType)
                self.fbAccount = accounts.last as! ACAccount
                let username = self.fbAccount.username
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    self.usernameLabel.text = username
                })
            } else if error != nil {
                let errorCode = UInt32(error.code)
                var title:String?
                var msg:String?
                if errorCode == ACErrorAccountNotFound.rawValue {
                    title = NSLocalizedString("No Account", comment: "No Account")
                    msg = NSLocalizedString("Please, login in settings", comment: "Please, login in settings")
                } else if errorCode == ACErrorPermissionDenied.rawValue {
                    title = NSLocalizedString("Permission Denied", comment: "Permission Denied")
                    msg = NSLocalizedString("Please, flip permissions in settings", comment: "Please, flip permissions in settings")
                } else {
                    title = error.localizedDescription
                    msg = error.localizedFailureReason
                }
                self.presentAlertWithTitle(title, message: msg)
            } else {
                let title = NSLocalizedString("Permission Denied", comment: "Permission Denied")
                let msg = NSLocalizedString("Please, flip permissions in settings", comment: "Please, flip permissions in settings")
                self.presentAlertWithTitle(title, message: msg)
            }
        }
    }
    
    func presentAlertWithTitle(title:String?, message:String?) {
        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
            let controller = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
            let cancelAction = UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: UIAlertActionStyle.Default, handler: nil)
            controller.addAction(cancelAction)
            self.presentViewController(controller, animated: true, completion: nil)
        })
    }
}