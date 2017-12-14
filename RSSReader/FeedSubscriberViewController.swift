//
//  FeedSubscriberViewController.swift
//  RSSReader
//
//  Created by plieblang on 12/2/17.
//  Copyright © 2017 plieblang. All rights reserved.
//

/*
 Takes a user-entered url and puts it in the list of subscriptions
 */

import UIKit

class FeedSubscriberViewController: UIViewController{
    
    @IBOutlet weak var feedURLField: UITextField!
    
    @IBOutlet var feedSubscriberViewController: UIView!

    @IBAction func screenTapped(_ sender: UITapGestureRecognizer) {
        feedURLField.resignFirstResponder()
    }
    
    @IBAction func subscribe(_ sender: Any) {
        
        if let fDict = UserDefaults.standard.dictionary(forKey: "petersrssreader"){
            //Only add the url if there's something there
            let entry: String = feedURLField.text!
            if fDict[entry] == nil || feedURLField.text! != ""{
                
                //This is inefficient because we're now parsing the whole xml twice
                let parser = XMLParser(contentsOf: URL(string: entry)!)
                if parser?.parse() == false{
                    let alert = UIAlertController(title: "Error", message: "That URL is invalid", preferredStyle: .alert)
                    let closeAlert = UIAlertAction(title: "OK", style: .cancel, handler: {(alert: UIAlertAction!) in return})
                    alert.addAction(closeAlert)
                    DispatchQueue.main.async {
                        self.present(alert, animated: true, completion: nil)
                    }
                    
                } else{
                    
                    var feedDict = fDict
                    feedDict[entry] = ""
                    UserDefaults.standard.set(feedDict, forKey: "petersrssreader")
                    feedURLField.resignFirstResponder()
                    let alert = UIAlertController(title: "Success", message: "You have subscribed to \(feedURLField.text!)", preferredStyle: .alert)
                    let closeAlert = UIAlertAction(title: "OK", style: .default, handler: {(alert: UIAlertAction!) in return})
                    alert.addAction(closeAlert)
                    DispatchQueue.main.async {
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        feedURLField.text = ""
    }
    
}
