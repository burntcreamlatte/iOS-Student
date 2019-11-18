//
//  Post.swift
//  Post
//
//  Created by Aaron Shackelford on 11/18/19.
//  Copyright © 2019 DevMtnStudent. All rights reserved.
//

import Foundation


struct Post: Decodable {
    let timestamp: TimeInterval?
    let username: String
    let text: String
    //let queryTimestamp
    
    init(username: String, text: String, timestamp: TimeInterval = Date().timeIntervalSince1970) {
        self.username = username
        self.text = text
        self.timestamp = timestamp
    }
}
