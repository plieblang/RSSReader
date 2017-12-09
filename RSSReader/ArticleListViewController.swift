//
//  ArticleViewController.swift
//  RSSReader
//
//  Created by plieblang on 11/29/17.
//  Copyright © 2017 plieblang. All rights reserved.
//

import UIKit
import SafariServices

class ArticleListViewController: UIViewController{
    
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
