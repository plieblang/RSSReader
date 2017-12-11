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
    
    @IBOutlet weak var feedNameField: UITextField!
    
    @IBOutlet weak var feedURLField: UITextField!
    
    @IBAction func subscribe(_ sender: Any) {
        
        //Check if we've already subscribed to a feed
        if let fDict = UserDefaults.standard.dictionary(forKey: "petersrssreader"){
            var feedDict = fDict as NSDictionary
            feedDict.setValue("", forKey: feedURLField.text!)
        } else{
            var feedList: NSDictionary = NSDictionary()
            feedList.setValue("", forKey: feedURLField.text!)
            UserDefaults().set(feedList, forKey: "petersrssreader")
        }
        
    }
    
}
