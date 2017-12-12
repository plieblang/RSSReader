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
    
    var feeds: NSDictionary = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.set(NSDictionary(), forKey: "petersrssreader")
        feeds = UserDefaults().dictionary(forKey: "petersrssreader")! as NSDictionary
    }
    
    override func viewDidAppear(_ animated: Bool) {
        feeds = UserDefaults().dictionary(forKey: "petersrssreader")! as NSDictionary
        
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
        //flatten dictionary into list, get indexPath.item from list and get that from dictionary
        var feedsList: [String] = []
        //there's gotta be a better way of doing this
        for (key, value) in feeds{
            feedsList.append(key as! String)
            
        }
        
        //Used as the key to get the url from feeds
        let feedName = feeds[feedsList[indexPath.item]]
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell", for: indexPath) as! FeedCell
        cell.feedNameLabel.text = feedName as? String
        return cell
    }
    
}
