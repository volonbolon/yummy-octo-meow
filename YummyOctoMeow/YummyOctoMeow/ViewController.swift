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
        let appID = "key" //
        let fbInfo = [ACFacebookAppIdKey:appID, ACFacebookPermissionsKey:["email"], ACFacebookAudienceKey:ACFacebookAudienceEveryone]
        self.accountStore.requestAccessToAccountsWithType(accountType, options: fbInfo as! [NSObject:AnyObject]) { (granted:Bool, error:NSError!) -> Void in
            if granted == true {
                println("Hola")
            } else {
                println("Nones")
            }
        }
    }

}



//
//-(void) facebookLogin
//    {
//        NSLog(@"Trying to access FB account.");
//        
//        self.accountStore = [[ACAccountStore alloc]init];
//        ACAccountType *FBaccountType= [self.accountStore
//        accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
//        
//        NSString *appID = @"1540000000000031"; //The app ID issued by Facebook
//        NSDictionary *dictFB = [NSDictionary dictionaryWithObjectsAndKeys:
//        appID, ACFacebookAppIdKey,
//        @[@"email"], ACFacebookPermissionsKey,
//        nil];
//        
//        [self.accountStore requestAccessToAccountsWithType:FBaccountType options:dictFB completion:
//        ^(BOOL granted, NSError *e) {
//        if (granted)
//        {
//        NSArray *accounts = [self.accountStore accountsWithAccountType:FBaccountType];
//        //it will always be the last object with single sign on
//        self.facebookAccount = [accounts lastObject];
//        
//        
//        ACAccountCredential *facebookCredential = [self.facebookAccount credential];
//        NSString *accessToken = [facebookCredential oauthToken];
//        NSLog(@"Successfully logged in. Access Token: %@", accessToken);
//        } else {
//        //Failed
//        NSLog(@"error getting permission: %@",e);
//        }
//        }];
//}
