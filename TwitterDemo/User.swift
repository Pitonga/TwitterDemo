//
//  User.swift
//  TwitterDemo
//
//  Created by Edwin M. Rivera on 2/21/16.
//  Copyright © 2016 CodePath Marky. All rights reserved.
//

import UIKit

class User: NSObject {
    var name: String?
    var screenname: NSString?
    var profileUrl: NSURL?
    var tagline: NSString?
    var dictionary: NSDictionary?
    var bannerImage: NSURL?
    var UserId: Int?
    var FollowingCount: Int
    var FollowersCount: Int
    var biography: NSString?
    
    var FollowingCountString: NSString
    var FollowersCountString: NSString
    
    
    init(dictionary: NSDictionary){
        self.dictionary = dictionary
        
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        
        let profileUrlString = dictionary["profile_image_url_https"] as? String
        if let profileUrlString = profileUrlString {
            profileUrl = NSURL(string: profileUrlString)
        }
        
        let bannerURLString = dictionary["profile_banner_url"] as? String
        if let bannerURLString = bannerURLString{
            bannerImage = NSURL(string: bannerURLString)
        }
        tagline = dictionary["description"] as? String
        
        FollowersCount = dictionary["followers_count"] as! Int
        FollowingCount = dictionary["friends_count"]as! Int
        FollowingCountString = "\(FollowingCount)"
        FollowersCountString = "\(FollowersCount)"
        biography = dictionary["description"] as! String
        UserId = dictionary["id"] as? Int
    }

    static let userDidLogoutNotification = "UserDidLogout"
    static var _currentUser: User?
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let defaults = NSUserDefaults.standardUserDefaults()
            
                let userData = defaults.objectForKey("currentUserData") as? NSData
        
                if let userData = userData {
                    let dictionary = try! NSJSONSerialization.JSONObjectWithData(userData, options: []) as! NSDictionary
                    _currentUser = User(dictionary: dictionary)
                }
            }
    
            return _currentUser
        }
        set (user){
            let defaults = NSUserDefaults.standardUserDefaults()
            
            
            if let user = user{
                let data = try! NSJSONSerialization.dataWithJSONObject(user.dictionary!, options: [])
        
                
                defaults.setObject(data, forKey: "currentUserData")
            } else {
                defaults.setObject(nil, forKey: "currentUserData")
            }
            defaults.synchronize()
        }
    }
    
}
