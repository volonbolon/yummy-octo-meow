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
        self.accountStore.requestAccessToAccountsWithType(accountType, options: fbInfo as! [NSObject:AnyObject]) { (granted:Bool, error:NSError!) -> Void in
            if granted == true {
                let accounts = self.accountStore.accountsWithAccountType(accountType)
                self.fbAccount = accounts.last as! ACAccount
                let username = self.fbAccount.username
                println("\(username)")
            } else {
                println("Nones")
            }
        }
    }

}
