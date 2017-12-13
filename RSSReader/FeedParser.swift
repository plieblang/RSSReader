//
//  FeedParser.swift
//  RSSReader
//
//  Created by plieblang on 10/30/17.
//  Copyright © 2017 plieblang. All rights reserved.
//

//TODO first article's title is cut off on https://feeds.howtogeek.com

import Foundation

class FeedParser: NSObject, XMLParserDelegate {
    
    var xmlParser: XMLParser!
    //What the current HTML tag is
    var currentTag: String = ""
    //This should be what we display to the user
    var articleTitle: String = ""
    var articleURL: String = ""
    //Represents a single article, which has those two attributes
    var singleArticle: Article = Article()
    //Holds all the articles in this feed
    var articleArray: [Article] = []
    //flag to check whether we’re parsing an actual feed item or its header (which also has a title, description, and so on)
    var headerFlag = true
    var feedTitle: String = ""
    //Used as cache key
    var feedURL: String = ""
    //Holds the articles for each feed
    var cache = NSCache<AnyObject, AnyObject>()
    var wholeTitleParsed: Bool = false
    var wholeLinkParsed: Bool = false
    
    func parseRssURL(rssURL: URL, completion: (NSCache<AnyObject, AnyObject>) -> ()) {
        feedURL = "\(rssURL)"
        let parser = XMLParser(contentsOf: rssURL)
        parser?.delegate = self
        parser?.parse()
        
        //How many articles each feed will keep at a time
        let cacheLimit = 50
        cache.countLimit = cacheLimit
        //cache.name = feedURL
        cache.setObject(articleArray as AnyObject, forKey: feedURL as AnyObject)
        completion(cache)
    }
    
    //Check the opening tag to see whether we're inside the header
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes: [String : String] = [:]) {
        
        currentTag = elementName
        
        //Need to know whether the link/title tags belong to the feed as a whole or an article
        if currentTag == "item"{
            
            headerFlag = false
            
        }
        
    }
    
    //Parse content inside tags
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        //Tracks whether it's safe to rename the feed, I think
        var flag: Bool = false
        
        //Set the cache name to be the feed's url
        if headerFlag == true{
            if currentTag == "title"{
                feedTitle = string
                flag = true
            }
            
            //rename the feed in UserDefaults
            if flag{
                if let fDict = UserDefaults.standard.dictionary(forKey: "petersrssreader"){
                    var feedDict = fDict as! [String: String]
                    feedDict[feedURL] = feedTitle
                    UserDefaults.standard.set(feedDict, forKey: "petersrssreader")
                }
            }
        } else {
            
            if currentTag == "title"{
                if wholeTitleParsed{
                    singleArticle.title = articleTitle
                    wholeTitleParsed = false
                    articleTitle = ""
                } else{
                    articleTitle += string.trimmingCharacters(in: .newlines).replacingOccurrences(of: "\t", with: "")
                }
            } else if currentTag == "link"{
                if wholeLinkParsed{
                    singleArticle.url = articleURL
                    wholeLinkParsed = false
                    articleURL = ""
                } else{
                    articleURL += string.trimmingCharacters(in: .newlines).replacingOccurrences(of: "\t", with: "")
                }
            }
            
        }
        
    }
    
    //Add the article when we hit the closing item tag
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if elementName == "item"{
            //TODO make sure we don't add duplicate articles
            articleArray.append(singleArticle)
        } else if elementName == "title"{
            wholeTitleParsed = true
        } else if elementName == "link"{
            wholeLinkParsed = true
        }
        
    }
    
}
