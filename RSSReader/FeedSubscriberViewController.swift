//
//  FeedSubscriberViewController.swift
//  RSSReader
//
//  Created by plieblang on 12/2/17.
//  Copyright © 2017 plieblang. All rights reserved.
//

/*
 Takes a user-entered url and puts it in the list of subscriptions
 */

import UIKit

class FeedSubscriberViewController: UIViewController{
    
    @IBOutlet weak var feedEntryField: UITextField!
    
    @IBAction func subscribe(_ sender: Any) {
        
        //Check if we've already subscribed to a feed
        if let fl = UserDefaults.standard.array(forKey: "petersrssreader"){
            var feedList = fl as NSArray
            feedList.adding(feedEntryField.text!)
        } else{
            var feedList: NSArray = []
            feedList.adding(feedEntryField.text!)
            UserDefaults().set(feedList, forKey: "petersrssreader")
        }
        
    }
    
}
