//
//  ViewController.swift
//  YummyOctoMeow
//
//  Created by Ariel Rodriguez on 8/10/15.
//  Copyright (c) 2015 Ariel Rodriguez. All rights reserved.
//

import UIKit
import Accounts

class ViewController: UIViewController, GPPSignInDelegate {
    @IBOutlet weak var usernameLabel: UILabel!
    
    var accountStore:ACAccountStore!
    var fbAccount:ACAccount!
    var gpSignIn:GPPSignIn?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup Google
        self.gpSignIn = GPPSignIn.sharedInstance()
        self.gpSignIn?.shouldFetchGooglePlusUser = true
        self.gpSignIn?.clientID = "914516035853-5j0lfk9jkdqjac5tvjajhg9ocslgjgu4.apps.googleusercontent.com"
        self.gpSignIn?.delegate = self
        self.gpSignIn?.scopes = [kGTLAuthScopePlusLogin, kGTLAuthScopePlusUserinfoEmail]
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signinWithGoogle(sender: AnyObject) {
        self.gpSignIn?.authenticate()
    }
    
    @IBAction func signinWithFacebook(sender: AnyObject) {
        self.facebookLogin()
    }
    // MARK: G+
    func finishedWithAuth(auth: GTMOAuth2Authentication!, error: NSError!) {
        guard error == nil else { return }

        let query = GTLQueryPlus.queryForPeopleGetWithUserId("me")
        
        let plusService = GTLServicePlus()
        plusService.retryEnabled = true
        plusService.authorizer = self.gpSignIn?.authentication
        plusService.apiVersion = "v1"
        plusService.executeQuery(query as! GTLQueryProtocol) { (ticket:GTLServiceTicket!, object:AnyObject!, error:NSError!) -> Void in
            if let person = object as? GTLPlusPerson {
                let email = person.emails.last as! GTLPlusPersonEmailsItem
                let userId = person.identifier
                self.usernameLabel.text = "email: \(email.value) || userId: \(userId)"
            }
        }
    }
    
    func didDisconnectWithError(error: NSError!) {
        print(error)
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