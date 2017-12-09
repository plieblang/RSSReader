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
    //Holds the list of subscribed feeds for UserDefaults
    var feedListCache: [String] = []
    
    @IBOutlet weak var feedEntryField: UITextField!
    
    @IBAction func subscribe(_ sender: Any) {
        
        //Check if we've already subscribed to a feed
        if feedListCache == UserDefaults.standard.stringArray(forKey: "petersrssreader")! {
            feedListCache.append(feedEntryField.text!)
        } else{
            feedListCache.append(feedEntryField.text!)
            UserDefaults().set(feedListCache, forKey: "petersrssreader")
        }
        
    }
    
}
