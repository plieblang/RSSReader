//
//  ArticlesEncoder.swift
//  RSSReader
//
//  Created by plieblang on 12/10/17.
//  Copyright © 2017 plieblang. All rights reserved.
//

/*
 Struct representing a single article inside a feed
 */

import Foundation

struct Article: Codable {
    var title: String = ""
    var url: String = ""
    var date: String = ""
    
    init(title: String = "", url: String = "", date: String = ""){
        self.title = title
        self.url = url
        self.date = date
    }
}
