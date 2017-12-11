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
    //Dictionary which maps headline to URL
    //Represents a single article, which has those two attributes
    var singleArticle: [String: String] = [:]
    //Holds all the article dictionaries
    var articleArray: [[String: String]] = []
    //flag to check whether we’re parsing an actual feed item or its header (which also has a title, description, and so on)
    var isHeader = true
    //Holds feed title to use as cache name
    var feedTitle: String = ""
    var feedURL: String = ""
    
    // MARK: XMLParser delegate methods
    func parseRssURL(rssURL: URL, with completion: (Bool)->()) {
        
        let parser = XMLParser(contentsOf: rssURL)
        parser?.delegate = self
        if let flag = parser?.parse() {
            // handle last item in feed
            articleArray.append(singleArticle)
            completion(flag)
        }
        
    }
    
    // look at opening tag
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        currentTag = elementName
        
        // news items start at <item> tag, we're not interested in header
        if currentTag == "item" || currentTag == "entry" {
            
            // at this point we're working with n+1 entry
            if isHeader == false {
                articleArray.append(singleArticle)
            }
            
            isHeader = false
            
        }
        
        /*
         if isHeader == false {
         
         // handle article thumbnails
         if currentTag == "media:thumbnail" || currentTag == "media:content" {
         tagContent += attributeDict["url"]!
         }
         
         }
         */
    }
    
    // keep relevant tag content
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        //Holds the articles for each feed
        var cache = NSCache<AnyObject, AnyObject>()
        //How many articles each feed will keep at a time
        let cacheLimit = 50
        //need to set cache.name to the feed url (ie example.com/rss.xml)
        cache.countLimit = cacheLimit
        
        //Set the cache name to be the feed's url
        if isHeader == true && currentTag == "link"{
            feedTitle = string
            cache.name = feedTitle
            
            //Check if we've already subscribed, and if not add to the list in UserDefaults
            if let fArr = UserDefaults.standard.array(forKey: "petersrssreader"){
                var feedsArray = fArr
                feedsArray.append([feedTitle: feedURL])
                let feedsPreppedForJSON = FeedsEncoder(feeds: feedsArray as! [[String : String]])
                let feedsAsJSON = try! JSONSerialization.data(withJSONObject: feedsPreppedForJSON, options: []) as NSData
                let feedsAsNSData = NSData.init(data: feedsAsJSON as Data)
                UserDefaults.standard.set(feedsAsNSData, forKey: feedTitle)
            }
        } else {
            
            //            if currentTag == "title" || currentTag == "link" || currentTag == "description" || currentTag == "content" || currentTag == "pubDate" || currentTag == "author" || currentTag == "dc:creator" || currentTag == "content:encoded" {
            //
            //                TODO: handle description inline HTML
            //                let additionalImages = foundCharacters.extractMatches(for: "img")
            //                if additionalImages.count > 0 {
            //                    let string = additionalImages[0] as NSString
            //                    currentData["inline_image"] = string.substring(with: NSRange(location: 10, length: string.length - 24))
            //                }
            //                foundCharacters = foundCharacters.deleteHTML(tags: ["a", "p", "div", "img"])
            //            }
            
            if currentTag == "title"{
                feedTitle = string
            } else if currentTag == "link"{
                //Add the current headline to the list of headlines for that feed
                singleArticle[feedTitle] = string
                articleArray.append(singleArticle)
                cache.setObject(articleArray as AnyObject, forKey: feedTitle as AnyObject)
            }
            
        }
        
    }
    
    // look at closing tag
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if !articleTitle.isEmpty {
            
            articleTitle = articleTitle.trimmingCharacters(in: .whitespacesAndNewlines)
            singleArticle[currentTag] = articleTitle
            articleTitle = ""
            
        }
        
    }
    
}
