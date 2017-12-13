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
        
        if let fDict = UserDefaults.standard.dictionary(forKey: "petersrssreader"){
            //Only parse the feed if the user hasn't already subscribed
            if fDict[feedURLField.text!] == nil{
                
                let fp = FeedParser()
                fp.parseRssURL(rssURL: URL(string: feedURLField.text!)!) { (cache) in
                    return
                }
            }
        }
    }
    
}
