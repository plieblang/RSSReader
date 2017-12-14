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
    //Need the second array so that all articles don't get put into the same array
    var articleArrayForCache: [Article] = []
    //flag to check whether we’re parsing an actual feed item or its header (which also has a title, description, and so on)
    var headerFlag = true
    var feedTitle: String = ""
    //Used as cache key
    var feedURL: String = ""
    var wholeTitleParsed: Bool = false
    var wholeLinkParsed: Bool = false
    
    let articleLimit = 50
    
    func parseRssURL(rssURL: URL, completion: (NSCache<AnyObject, AnyObject>) -> ()) {
        feedURL = "\(rssURL)"
        let parser = XMLParser(contentsOf: rssURL)
        parser?.delegate = self
        parser?.parse()
        
        //Holds the articles for each feed
        var cache = NSCache<AnyObject, AnyObject>()
        //How many feeds the cache can hold
        let cacheLimit = 256
        cache.countLimit = cacheLimit
        //remove invalid article that shows up in the first subscribed feed
        articleArrayForCache = articleArrayForCache.filter(){ $0.url != ""}
        cache.setObject(articleArrayForCache as AnyObject, forKey: feedURL as AnyObject)
        articleArrayForCache.removeAll()
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
        
        if headerFlag == true{
            if currentTag == "title"{
                if wholeTitleParsed{

                    if let fDict = UserDefaults.standard.dictionary(forKey: "petersrssreader"){
                        var feedDict = fDict as! [String: String]
                        feedDict[feedURL] = feedTitle
                        UserDefaults.standard.set(feedDict, forKey: "petersrssreader")
                    }
                    
                    wholeTitleParsed = false
                    
                } else{
                    feedTitle += string.trimmingCharacters(in: .newlines).replacingOccurrences(of: "\t", with: "")
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
            //limit the number of articles
            if articleArray.count > articleLimit{
                for i in 0..<articleLimit - 1{
                    articleArray[i] = articleArray[i+1]
                }
                articleArray[articleLimit - 1] = singleArticle
            } else{
                self.articleArray.append(self.singleArticle)
            }
        } else if elementName == "title"{
            wholeTitleParsed = true
        } else if elementName == "link"{
            wholeLinkParsed = true
        } else if elementName == "channel"{
            articleArrayForCache = articleArray
            articleArray.removeAll()
        }
        
    }
    
}
