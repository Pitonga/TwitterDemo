//
//  TwitterClient.swift
//  TwitterDemo
//
//  Created by Edwin M. Rivera on 2/21/16.
//  Copyright © 2016 CodePath Marky. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
    
    
    static let sharedInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com")!, consumerKey: "O6zDuSC3J41jcbktVy6ZmPPKd", consumerSecret: "p68GqXsw5ugkv6TFTVeMWaM28wRvccOpirLWlfr0YML5VyS7eq")
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((NSError) -> ())?
    
    
    
    func handleOpenUrl(url: NSURL){
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential!) -> Void in
            self.currentAccount({ (user: User) -> () in
                User.currentUser = user
                self.loginSuccess?()
            }, failure: { (error: NSError) -> () in
                    self.loginFailure?(error)
            })
            
            
            }) { (error: NSError!) -> Void in
                print("error: \(error.localizedDescription)")
            self.loginFailure?(error)
        }
        
    }
    
    func homeTimeline(success: ([Tweet]) -> (), failure: (NSError) -> ()) {
        
        GET("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let dictionaries = response as! [NSDictionary]
            
            let tweets = Tweet.tweetsWithArray(dictionaries)
            
            success(tweets)
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
            })
    
    }

    func currentAccount(success: (User) -> (), failure: (NSError) -> ()){
        GET("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            
            success(user)
        
            
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        })

    }
    
    func login(success: () -> (), failure: (NSError) -> ()){
        loginSuccess = success
        loginFailure = failure
        
        
        TwitterClient.sharedInstance.deauthorize()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "twitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            
            let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")!
            UIApplication.sharedApplication().openURL(url)
            }) { (error: NSError!) -> Void in
                print("error: \(error.localizedDescription)")
                self.loginFailure?(error)
        }

    }
    
    func logout() {
        User.currentUser = nil
        deauthorize()
        
        NSNotificationCenter.defaultCenter().postNotificationName(User.userDidLogoutNotification, object: nil)
    }
    
    func retweet(id:String){
         POST("1.1/statuses/retweet/\(id).json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            print("Succesfully retweeted")
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                print("Failed to retweet")
         })
    
    }
    
    func unretweet(id:String){
        POST("1.1/statuses/unretweet/\(id).json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            print("Succesfully unretweeted")
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                print("Failed to unretweet")
        })
        
    }
    
    
    func favorited(id:String){
        POST("1.1/favorites/create.json?id=\(id)", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            print("Succesfully favorited")
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                print("Failed to favorite")
        })
        
    }

    func unfavorited(id:String){
        POST("1.1/favorites/destroy.json?id=\(id)", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            print("Succesfully unfavorited")
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                print("Failed to unfavorite")
        })
        
    }
    
    func RetrieveUser (UserID: Int )( success: (User) -> (), failure: (NSError) -> ()){
        
        GET("https://api.twitter.com/1.1/users/show.json?id=\(UserID)", parameters:nil , progress: nil, success: { (task :NSURLSessionDataTask,
            response: AnyObject?) -> Void in
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            
            success (user)
            
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        })
        
        
    }
    
    func UserTimeLine(UserID: Int )( success: ([Tweet]) -> (), failure: (NSError) -> ()){
        
        GET("https://api.twitter.com/1.1/statuses/user_timeline.json?id=\(UserID)", parameters:nil , progress: nil, success: { (task :NSURLSessionDataTask,
            response: AnyObject?) -> Void in
            
            
            let responseDictionary = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(responseDictionary)
            
            success (tweets)
            
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        })
    }
    

    func SendTweet(status:String){
        let status = (status.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding))!
        POST("1.1/statuses/update.json?status=\(status)", parameters: nil,
            success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
                print("Succesfull Tweet")
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                print("Tweet error:\(error)")
        })
        
    }
    
    func reply(tweetId: String, tweetText: String) {
        let replyText = (tweetText.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding))!
        
        POST("1.1/statuses/update.json?status=\(replyText)&in_reply_to_status_id=\(tweetId)", parameters: nil,
            success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
                print("Success: replied sent")
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                print("Reply error:\(error)")
        })
        
    }
    
    
}