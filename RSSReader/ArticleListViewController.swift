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
    
    //url as string
    var feedCacheID: String = ""
    var articles: [Article] = []
    var cache: NSCache<AnyObject, AnyObject> = NSCache()
    
    @IBOutlet weak var articleHeadline: UILabel!
    
    @IBOutlet weak var articleListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        articleListTableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setArticles()
        
        DispatchQueue.main.async {
            self.articleListTableView.reloadData()
        }
    }
    
    func setArticles(){
        articles = cache.object(forKey: feedCacheID as AnyObject) as! [Article]
    }
    
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
        //TODO THIS IS NOT A GOOD FIX
        //should have a real check for whether the url is valid or not
        //Needed because for some reason, the first feed you subscribe to has a blank slot at the top
        if article.url != ""{
            cell.configure(url: URL(string: article.url)!, title: article.title)
        } else {
            cell.configure(url: URL(string: "https://duckduckgo.com")!, title: "DuckDuckGo")
        }
        return cell
    }
    
}
