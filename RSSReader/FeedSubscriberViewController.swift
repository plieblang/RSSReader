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
        
        //TODO Don't resubscribe
        if let fDict = UserDefaults.standard.dictionary(forKey: "petersrssreader"){
            var feedDict = fDict as! [String: String]
            var feedProps: [String] = []
            let fp = FeedParser()
            fp.getRssProperties(rssURL: URL(string: feedURLField.text!)!){ (newFeedProperties) in
                feedProps = newFeedProperties
                feedDict[feedProps[0]] = feedProps[1]
                UserDefaults().set(feedDict as NSDictionary, forKey: "petersrssreader")
            }
            
            fp.parseRssURL(rssURL: URL(string: feedURLField.text!)!){ (articleArr) in
                let cache = NSCache<AnyObject, AnyObject>()
                //TODO cache holds articles, not a list of articles
                var articleArray: [Article] = cache.object(forKey: feedProps[0] as AnyObject) as! [Article]
                
                //TODO get rid of this because we're already checking for duplicates articles in FeedParser
                for current in articleArr{
                    //need to check if current is already in articleArray without double for loops
                    var seen: Bool = false
                    for a in articleArray{
                        if current.url == a.url{
                            seen = true
                            break
                        }
                    }
                    
                    if !seen{
                        articleArray.append(current)
                    }
                }
            }
        } else{
            var feedDict: [String: String] = [:]
            var feedProps: [String] = []
            let fp = FeedParser()
            fp.getRssProperties(rssURL: URL(string: feedURLField.text!)!){ (newFeedProperties)  in
                feedProps = newFeedProperties
                feedDict[feedProps[0]] = feedProps[1]
                UserDefaults().set(feedDict as NSDictionary, forKey: "petersrssreader")
            }
            
            fp.parseRssURL(rssURL: URL(string: feedURLField.text!)!){ (articleArr) in
                let cache = NSCache<AnyObject, AnyObject>()
                var articleArray: [Article] = []
                
                for current in articleArr{
                    articleArray.append(current)
                }
                
                cache.setObject(articleArray as AnyObject, forKey: feedProps[0] as AnyObject)
            }
        }
    }
    
}
