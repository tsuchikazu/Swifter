//
//  FriendListViewController.swift
//  SwifterDemo
//
//  Created by 土屋 和良 on 2014/09/07.
//  Copyright (c) 2014年 Kazuyoshi Tsuchiya. All rights reserved.
//

import UIKit
import Accounts
import Social
import SwifteriOS
class FriendListViewController : UITableViewController {
    var friends :[JSONValue] = []
    var swifter: Swifter
    
    
    required init(coder aDecoder: NSCoder) {
        self.swifter = Swifter(consumerKey: "RErEmzj7ijDkJr60ayE2gjSHT", consumerSecret: "SbS0CHk11oJdALARa7NDik0nty4pXvAxdt7aj0R5y1gNzWaNEx")
        super.init(coder: aDecoder)
    }
    
    override func viewWillAppear(animated: Bool) {
        // twitter account
        let accountStore = ACAccountStore()
        let twitterAccounts = accountStore.accountsWithAccountType(accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter))
        self.swifter = Swifter(account: twitterAccounts[0] as ACAccount)
        
        // get friends list
        self.swifter.getAccountVerifyCredentials(false, skipStatus: true, success: { (myInfo: Dictionary<String, JSONValue>?) -> Void in
            
            println(myInfo?["id"])
            println(myInfo?["screen_name"])
            println(myInfo?["profile_image_url"])
            
            
            var screenName : String = myInfo!["screen_name"]!.string!
            self.swifter.getFriendsListWithScreenName(screenName, cursor: nil, count: 200, skipStatus: false, includeUserEntities: false, success: { (users, previousCursor, nextCursor) -> Void in
                for friend in users! {
                    println(friend["id"])
                    println(friend["screen_name"])
                    println(friend["profile_image_url"])
                }
                
                
                self.friends = users!
                self.tableView.reloadData()
                
                }, failure: nil)
            }) { (error) -> Void in
                println(error)
        }
        
        
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "FriendTableViewCellIdentifier")
        
        cell.textLabel?.text = friends[indexPath.row]["screen_name"].string
        
        
        var profile_image_url : String = friends[indexPath.row]["profile_image_url"].string!
        var url = NSURL(string: profile_image_url)
        var data = NSData.dataWithContentsOfURL(url, options: nil, error: nil)
        cell.imageView?.image = UIImage(data: data)
        
        return cell
    }
    
    func alertWithTitle(title: String, message: String) {
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: { () -> Void in
            
            let url = NSURL(string:UIApplicationOpenSettingsURLString)
            UIApplication.sharedApplication().openURL(url)
        })
    }
    
}