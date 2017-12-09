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
    //What the content enclosed by the tag is
    //This will probably be what we display to the user
    var title: String = ""
    var url: String = ""//should it be a URL or string?
    var currentData: [String: String] = [:]
    var parsedData: [[String:String]] = []
    //flag to check whether we’re parsing an actual feed item or its header (which also has a title, description, and so on)
    var isHeader = true
    //Holds the articles for each feed
    var cache = NSCache<AnyObject, AnyObject>()
    //How many articles each feed will keep at a time
    let cacheLimit = 50
    
    // MARK: XMLParser delegate methods
    func parseRssURL(rssURL: URL, with completion: (Bool)->()) {
        
        let parser = XMLParser(contentsOf: rssURL)
        parser?.delegate = self
        if let flag = parser?.parse() {
            // handle last item in feed
            parsedData.append(currentData)
            completion(flag)
        }
        
        //need to set cache.name to the feed url (ie example.com/rss.xml)
        cache.countLimit = cacheLimit
        
    }
    
    // look at opening tag
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        currentTag = elementName
        
        // news items start at <item> tag, we're not interested in header
        if currentTag == "item" || currentTag == "entry" {
            
            // at this point we're working with n+1 entry
            if isHeader == false {
                parsedData.append(currentData)
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
        
        if isHeader == false {
            
            /*
            if currentTag == "title" || currentTag == "link" || currentTag == "description" || currentTag == "content" || currentTag == "pubDate" || currentTag == "author" || currentTag == "dc:creator" || currentTag == "content:encoded" {*/
            if currentTag == "title"{
                title = string
                
                // TODO: handle description inline HTML
                //                let additionalImages = foundCharacters.extractMatches(for: "img")
                //                if additionalImages.count > 0 {
                //                    let string = additionalImages[0] as NSString
                //                    currentData["inline_image"] = string.substring(with: NSRange(location: 10, length: string.length - 24))
                //                }
                //foundCharacters = foundCharacters.deleteHTML(tags: ["a", "p", "div", "img"])
            } else if currentTag == "link"{
                url = string
            }
            
        }
        
    }
    
    // look at closing tag
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if !title.isEmpty {
            
            title = title.trimmingCharacters(in: .whitespacesAndNewlines)
            currentData[currentTag] = title
            title = ""
            
        }
        
    }
    
}
