//
//  Tweet.swift
//  TwitterDemo
//
//  Created by Edwin M. Rivera on 2/21/16.
//  Copyright © 2016 CodePath Marky. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    
    var text: NSString?
    var timestamp: NSDate?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    var timestampString: String?
    
    init(dictionary: NSDictionary){
        text = dictionary["text"] as? String
        
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (dictionary["favourites_count"] as? Int) ?? 0
        
        timestampString = dictionary["created_at"] as? String
    
        if let timestampString = timestampString{
            let formatter = NSDateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.dateFromString(timestampString)
        }
    }
 
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
       var tweets = [Tweet]()
        
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            
            tweets.append(tweet)
        }
        return tweets
    }
    
    func retweet(value: Int){
        if value == 1 {
            retweetCount += 1;
        }
        else{
            retweetCount -= 1;
        }
    }
    
    func favorite(value: Int){
        if value == 1 {
            favoritesCount += 1;
        }
        else if value == -1 {
            favoritesCount -= 1;
        }

    }
}