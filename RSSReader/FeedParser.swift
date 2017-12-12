//
//  FeedParser.swift
//  RSSReader
//
//  Created by plieblang on 10/30/17.
//  Copyright © 2017 plieblang. All rights reserved.
//

import Foundation

class FeedParser: NSObject, XMLParserDelegate {
    
    var xmlParser: XMLParser!
    //What the current HTML tag is
    var currentTag: String = ""
    //This will probably be what we display to the user
    var articleTitle: String = ""
    var articleURL: String = ""//should it be a URL or string?
    //Represents a single article, which has those two attributes
    var singleArticle: Article = Article()
//    //Holds all the article dictionaries
//    var articleArray: [Article] = []
    //flag to check whether we’re parsing an actual feed item or its header (which also has a title, description, and so on)
    var headerFlag = true
    //Holds feed title to use as cache name
    var feedTitle: String = ""
    var feedURL: String = ""
    //Holds the articles for each feed
    var cache = NSCache<AnyObject, AnyObject>()
    var wholeStringParsed: Bool = false
    
    //Returns the cache of articles
    func parseRssURL(rssURL: URL, completion: (NSCache<AnyObject, AnyObject>) -> ()) {
        
        let parser = XMLParser(contentsOf: rssURL)
        parser?.delegate = self
        if parser?.parse() == true{
            completion(cache)
        }
        
    }
    
    //Returns a two-slot list of strings where [0] is the url and [1] is the title
    func getRssProperties(rssURL: URL, completion: ([String]) -> ()){
        
        //This is inefficient because it parses the whole feed just to get its title and url
        let parser = XMLParser(contentsOf: rssURL)
        parser?.delegate = self
        if parser?.parse() == true{
            completion([feedURL, feedTitle])
        }
        
    }
    
    //Check the opening tag to see whether we're inside the header
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes: [String : String] = [:]) {
        
        currentTag = elementName
        
        //Need to know whether the link/title tags belong to the feed as a whole or an article
        if currentTag == "item"{
            
            headerFlag = false
            
        }
        
    }
    
    // keep relevant tag content
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        //How many articles each feed will keep at a time
        let cacheLimit = 50
        cache.countLimit = cacheLimit
        
        var flag: Bool = false
        
        //Set the cache name to be the feed's url
        if headerFlag == true{
            if currentTag == "title"{
                feedTitle = string
                flag = true
            } else if currentTag == "link"{
                feedURL = string
                cache.name = feedURL
                flag = true
            }
            
            //rename the existing dictionary entry
            if flag{
                if let fDict = UserDefaults.standard.dictionary(forKey: "petersrssreader"){
                    var feedDict = fDict as! [String: String]
                    feedDict[feedURL] = feedTitle
                    UserDefaults.standard.set(feedDict, forKey: "petersrssreader")
                }
            }
        } else {
            
            if currentTag == "title"{
                if wholeStringParsed{
                    singleArticle.title = articleTitle
                    articleTitle = string.trimmingCharacters(in: .newlines).replacingOccurrences(of: "\t", with: "")
                } else{
                    articleTitle += string.trimmingCharacters(in: .newlines).replacingOccurrences(of: "\t", with: "")
                }
                
                
            } else if currentTag == "link"{
                if wholeStringParsed{
                    singleArticle.url = articleURL
                    //link always comes after title, so we can add the article now
                    articleURL = string.trimmingCharacters(in: .whitespacesAndNewlines)
                } else{
                    articleURL += string.trimmingCharacters(in: .whitespacesAndNewlines)
                }
                
            }
            
        }
        
    }
    
    //Add the article when we hit the closing item tag
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if elementName == "item"{
            //TODO check for duplicate items and merge the two caches
            if var feedCache = cache.object(forKey: feedURL as AnyObject){
                if feedCache.object(forKey: articleURL as AnyObject) != nil{
                    feedCache.set(articleTitle, forKey: articleURL)
                }
            }
            wholeStringParsed = true
        }
        
    }
    
}
