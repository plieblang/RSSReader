//
//  FeedViewController.swift
//  RSSReader
//
//  Created by plieblang on 11/29/17.
//  Copyright © 2017 plieblang. All rights reserved.
//

import UIKit

class FeedListViewController: UIViewController {
    
    var feeds: NSDictionary = [:]
    var feedToCache: [String: NSCache<AnyObject, AnyObject>] = [:]
    
    @IBOutlet weak var feedListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        feedListTableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.standard.object(forKey: "petersrssreader") == nil{
            //Needed so that there's something in UserDefaults
            //TODO remove
            let preload: NSDictionary = ["https://www.nationalreview.com/rss.xml": "National Review"]
            UserDefaults.standard.set(NSDictionary(), forKey: "petersrssreader")
        }
        
        if let f = UserDefaults().dictionary(forKey: "petersrssreader"){
            feeds = f as NSDictionary
            let fp = FeedParser()
            for (key, value) in feeds{
                let url = URL(string: key as! String)
                if UIApplication.shared.canOpenURL(url!){
                    fp.parseRssURL(rssURL: url!) { (cache) in
                        if feedToCache[String(describing: url)] == nil{
                            feedToCache[String(describing: url)] = cache
                        }
                    }
                }
            }
        }
        
        DispatchQueue.main.async {
            self.feedListTableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? ArticleListViewController else { return }
        guard let source = sender as? FeedCell else { return }
        destination.feedCacheID = source.feedCacheID
        destination.cache = source.cache
    }
    
    @IBAction func removeFeed(_ sender: Any) {
        if let feedListForRemoving = UserDefaults.standard.dictionary(forKey: "petersrssreader"){
            var newFeedList = feedListForRemoving as! [String: String]
            let cellToRemove = sender as! FeedCell
            newFeedList.removeValue(forKey: cellToRemove.feedCacheID)
            UserDefaults.standard.set(newFeedList, forKey: cellToRemove.feedCacheID)
        }
    }
    
}

extension FeedListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feeds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //flatten dictionary into list, get indexPath.item from list and get that from dictionary
        var feedsList: [String] = []
        for (key, value) in feeds{
            feedsList.append(key as! String)
        }
        
        //Used as the key to get the url from feeds
        let feedName = feedsList[indexPath.item]
        let feedCache = feedToCache[feedName]
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell", for: indexPath) as! FeedCell
        cell.configure(name: feedName, feedCacheID: feedName, cache: feedCache!)
        return cell
    }
    
}
