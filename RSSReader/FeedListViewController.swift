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
    var feedCacheMap: [String: NSCache<AnyObject, AnyObject>] = [:]
    
    @IBOutlet weak var feedListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        feedListTableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.standard.object(forKey: "petersrssreader") == nil{
            //Needed so that there's something in UserDefaults
            UserDefaults.standard.set(NSDictionary(), forKey: "petersrssreader")
        }
        
        if let f = UserDefaults().dictionary(forKey: "petersrssreader"){
            feeds = f as NSDictionary
            let fp = FeedParser()
            for (key, value) in feeds{
                let urlAsString: String = key as! String
                let url = URL(string: urlAsString)
                if UIApplication.shared.canOpenURL(url!){
                    //Parse each stored feed and map the feed's url/id to its article cache
                    fp.parseRssURL(rssURL: url!) { (cache) in
                        feedCacheMap[urlAsString] = cache
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
    
}

extension FeedListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feeds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //flatten dictionary into list to get indexPath.item from it
        var feedsList: [String] = []
        for (key, value) in feedCacheMap{
            feedsList.append(key)
        }
        
        //Used as the key to get the url from feeds
        let feedURL = feedsList[indexPath.item]
        let feedName = feeds[feedURL]
        let feedCache = feedCacheMap[feedURL]
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell", for: indexPath) as! FeedCell
        //name should be feedName but it doesn't work properly
        cell.configure(name: feedName as! String, feedCacheID: feedURL, cache: feedCache!)
        DispatchQueue.main.async {
            self.feedListTableView.reloadData()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            if let feedListForRemoving = UserDefaults.standard.dictionary(forKey: "petersrssreader"){
                if feedListForRemoving.count <= 1{
                    UserDefaults.standard.set(NSDictionary(), forKey: "petersrssreader")
                }
                
                var feedsList: [String] = []
                for (key, value) in feedCacheMap{
                    feedsList.append(key)
                }
                var newFeedList = feedListForRemoving as! [String: String]
                newFeedList.removeValue(forKey: feedsList[indexPath.item])
                UserDefaults.standard.set(newFeedList, forKey: "petersrssreader")
            }
            
            DispatchQueue.main.async {
                self.feedListTableView.reloadData()
            }
        }
    }
    
}
