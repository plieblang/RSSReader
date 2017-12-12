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
            let fp = FeedParser()
            fp.parseRssURL(rssURL: URL(string: feedURLField.text!)!){ (done)  in
                feedDict.setValue("", forKey: feedURLField.text!)
                UserDefaults().set(feedDict, forKey: "petersrssreader")
            }
            
        } else{
            var feedDict: NSDictionary = NSDictionary()
            let fp = FeedParser()
            fp.parseRssURL(rssURL: URL(string: feedURLField.text!)!){ (done)  in
                feedDict.setValue("", forKey: feedURLField.text!)
                UserDefaults().set(feedDict, forKey: "petersrssreader")
            }
            
        }
        
    }
    
}
