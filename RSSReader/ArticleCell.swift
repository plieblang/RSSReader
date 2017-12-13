//
//  ArticleCell.swift
//  RSSReader
//
//  Created by plieblang on 11/29/17.
//  Copyright © 2017 plieblang. All rights reserved.
//

/*
 Handles tapping on a specific headline inside a list of headlines
 whether inside the master list of articles or the more localized list for each feed
 */

import UIKit
import SafariServices

class ArticleCell: UITableViewCell{
    
    var url: URL!
    var title: String = ""
    var parentViewController: UIViewController!
    
    @IBOutlet weak var articleHeadline: UIButton!
    
    func configure(url: URL, title: String) {
        self.url = url
        self.title = title
        self.articleHeadline.setTitle(title, for: UIControlState.normal)
    }
    
    @IBAction func headlineTapped(_ sender: Any) {
        let safariVC = SFSafariViewController(url: url)
        parentViewController.navigationController?.pushViewController(safariVC, animated: true)
    }
    
}
