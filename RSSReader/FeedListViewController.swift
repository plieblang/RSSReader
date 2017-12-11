//
//  FeedViewController.swift
//  RSSReader
//
//  Created by plieblang on 11/29/17.
//  Copyright © 2017 plieblang. All rights reserved.
//

/*
 need to get the list of feeds from userdefaults
 */

import UIKit

class FeedListViewController: UIViewController {
    
    var feeds: [[String: String]] = []
    var feedsAsNSData = UserDefaults().array(forKey: "petersrssreader")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let feedsPreppedForJSON = FeedsEncoder(feeds: feedsAsNSData as! [[String : String]])
        let feedsAsJSON = try! JSONSerialization.jsonObject(with: self.feedsAsNSData, options: [])//JSONSerialization.data(withJSONObject: feedsPreppedForJSON, options: []) as NSData
        feeds = feedsAsJSON.feeds
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? ArticleListViewController else { return }
        guard let source = sender as? FeedCell else { return }
        destination.feedName = source.name
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
        let feed = feeds[indexPath.item]
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell", for: indexPath) as! FeedCell
        for (key, value) in feed{
            cell.feedNameLabel.text = key
        }
        return cell
    }
    
}
