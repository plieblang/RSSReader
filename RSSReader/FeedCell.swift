//
//  ArticleCell.swift
//  RSSReader
//
//  Created by plieblang on 11/29/17.
//  Copyright © 2017 plieblang. All rights reserved.
//

/*
 This cell handles taps on an individual feed inside the table of all available feeds
 */

import UIKit
import SafariServices

class FeedCell: UITableViewCell{
    
    @IBOutlet weak var feedNameLabel: UILabel!
    
    var feedCacheID: String = ""
    var cache: NSCache<AnyObject, AnyObject> = NSCache()
    
    func configure(name: String, feedCacheID: String, cache: NSCache<AnyObject, AnyObject>) {
        feedNameLabel.text = name
        self.feedCacheID = feedCacheID
        self.cache = cache
    }
    
}
