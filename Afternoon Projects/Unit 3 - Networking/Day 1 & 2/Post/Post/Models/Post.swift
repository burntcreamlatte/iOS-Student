//
//  Post.swift
//  Post
//
//  Created by Aaron Shackelford on 11/18/19.
//  Copyright © 2019 DevMtnStudent. All rights reserved.
//

import Foundation


struct Post: Codable {
    let timestamp: TimeInterval
    let username: String
    let text: String
    //TODO; CORRECTLY IMPLEMENT COMPUTED PROPERTY
    var queryTimestamp: TimeInterval {
        return self.timestamp - 0.00001
    }
    
    init(username: String, text: String, timestamp: TimeInterval = Date().timeIntervalSince1970) {
        self.username = username
        self.text = text
        self.timestamp = timestamp
    }
}
