//
//  Tweet.swift
//  W3_Twitter
//
//  Created by Phuong Thao Tran on 3/3/17.
//  Copyright © 2017 Phuong Thao Tran. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var user: User?
    var text: String?
    var createdAtString: String?
    var createdAt: Date?
    var timeSinceCreated: String?
    
    var retweetCount = 0
    var favCount = 0
    
    
    init(dictionary: NSDictionary) {
        
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        retweetCount = (dictionary["retweet_count"] as? Int)!
        favCount = (dictionary["favorite_count"] as? Int)!
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = formatter.date(from: createdAtString!)
        
        let elapsedTime = Date().timeIntervalSince(createdAt!)
        if elapsedTime < 60 {
            timeSinceCreated = String(Int(elapsedTime)) + "s"
        } else if elapsedTime < 3600 {
            timeSinceCreated = String(Int(elapsedTime / 60)) + "m"
        } else if elapsedTime < 24*3600 {
            timeSinceCreated = String(Int(elapsedTime / 60 / 60)) + "h"
        } else {
            timeSinceCreated = String(Int(elapsedTime / 60 / 60 / 24)) + "d"
        }
        
    }
    
    class func tweetsWithArray(_ array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dict in array {
            tweets.append(Tweet(dictionary: dict))
        }
        return tweets
    }
}
