//
//  ArticleCell.swift
//  RSSReader
//
//  Created by plieblang on 11/29/17.
//  Copyright © 2017 plieblang. All rights reserved.
//

/*
 This cell is for each individual feed
 if handling taps on an individual feed inside the table of all available feeds
 */

import UIKit
import SafariServices

class FeedCell: UITableViewCell{
    
    @IBOutlet weak var feedName: UILabel!
    
    var url: URL!
    var parentViewController: UIViewController!
    
    func configure(url: URL, parentViewController: UIViewController) {
        self.url = url
        self.parentViewController = parentViewController
    }
    
}
