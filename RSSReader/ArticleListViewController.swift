//
//  ArticleViewController.swift
//  RSSReader
//
//  Created by plieblang on 11/29/17.
//  Copyright © 2017 plieblang. All rights reserved.
//

/*
 View Controller for the articles in a single feed
 need to get them from the cache where the key is the feed url
 */

import UIKit
import SafariServices

class ArticleListViewController: UIViewController{
    
    var feedName: String = ""
    var articles: [String] = []
    
    @IBOutlet weak var articleHeadline: UILabel!

    
}

extension ArticleListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let article = articles[indexPath.item]
        let cell = tableView.dequeueReusableCell(withIdentifier: "articleCell", for: indexPath) as! ArticleCell
        cell.articleHeadline.setTitle(article, for: UIControlState.normal)
        return cell
    }
    
}
