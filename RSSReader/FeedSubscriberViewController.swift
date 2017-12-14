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
            if fDict[entry] == nil && feedURLField.text! != ""{
                
                let request = URLRequest(url: URL(string: entry)!)
                
                let getFeedTask = URLSession(configuration: .ephemeral).dataTask(with: request){ (data, response, error) in
                    if let responseStatus = response as? HTTPURLResponse{
                        let status = responseStatus.statusCode
                        //received a valid response so continue
                        if status == 200{
                            
                            //This is inefficient because we're now parsing the whole xml twice
                            let parser = XMLParser(data: data!)
                            if parser.parse() == false{
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
                                DispatchQueue.main.async {
                                    self.feedURLField.resignFirstResponder()
                                    let alert = UIAlertController(title: "Success", message: "You have subscribed to \(self.feedURLField.text!)", preferredStyle: .alert)
                                    let closeAlert = UIAlertAction(title: "OK", style: .default, handler: {(alert: UIAlertAction!) in return})
                                    self.present(alert, animated: true, completion: nil)
                                    alert.addAction(closeAlert)
                                }
                            }
                            
                        } else{
                            let alert = UIAlertController(title: "Error", message: "Sorry, could not find that URL", preferredStyle: .alert)
                            let closeAlert = UIAlertAction(title: "OK", style: .cancel, handler: {(alert: UIAlertAction!) in return})
                            alert.addAction(closeAlert)
                        }
                    
                    }
                }
                getFeedTask.resume()
            }
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        feedURLField.text = ""
    }
    
}
