//
//  FeedViewController.swift
//  RSSReader
//
//  Created by plieblang on 11/29/17.
//  Copyright © 2017 plieblang. All rights reserved.
//

import UIKit

class FeedListViewController: UIViewController {
    
    var feeds: [String] = UserDefaults().array(forKey: "petersrssreader") as! [String]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        cell.feedName.text = feed
        return cell
    }
    
}
