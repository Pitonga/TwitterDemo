//
//  TweetsDetailViewController.swift
//  TwitterDemo
//
//  Created by Edwin M. Rivera on 3/1/16.
//  Copyright © 2016 CodePath Marky. All rights reserved.
//

import UIKit

class TweetsDetailViewController: UIViewController {
    
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var LikeButton: UIButton!
    
    @IBOutlet weak var RTButton: UIButton!
    
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var accountIDLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var retweetCount: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    
    var tweet: Tweet?
    
    var favorited = false
    var retweeted = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImage.layer.cornerRadius = 10
        profileImage.clipsToBounds = true
        userNameLabel.text = tweet!.user?.name as String!
        profileImage.setImageWithURL((tweet!.user?.profileUrl)!)
        accountIDLabel.text = "@\((tweet!.user?.screenname)!)"
        timeStampLabel.text = tweet!.timestampString! as String
        tweetTextLabel.text = tweet!.text as? String
        tweetTextLabel.sizeToFit()
        tweetTextLabel.preferredMaxLayoutWidth = tweetTextLabel.frame.size.width
        retweetCount.text = String(tweet!.retweetCount) as String
        likeCountLabel.text = String(tweet!.favoritesCount)as String
        
        RTButton.setBackgroundImage(UIImage(named: "retweet"), forState: .Normal)
        LikeButton.setBackgroundImage(UIImage(named: "favorite"), forState: .Normal)
        
        replyButton.setBackgroundImage(UIImage(named: "reply"), forState: .Normal)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func onRTButton(sender: AnyObject) {
        if !retweeted {
            TwitterClient.sharedInstance.retweet(tweet!.tweetID!)
            RTButton.setBackgroundImage(UIImage(named: "retweeted"), forState: .Normal)
            retweetCount.text = String(tweet!.retweetCount + 1)
            retweeted = true
        }
        else{
            TwitterClient.sharedInstance.unretweet(tweet!.tweetID!)
            RTButton.setBackgroundImage(UIImage(named: "retweet"), forState: .Normal)
            retweetCount.text = String(tweet!.retweetCount)
            retweeted = false
            
        }
        
    }
    
    @IBAction func onLikeButtonAction(sender: AnyObject) {
        
        if !favorited {
            TwitterClient.sharedInstance.favorited(tweet!.tweetID!)
            LikeButton.setBackgroundImage(UIImage(named: "favorited"), forState: .Normal)
            likeCountLabel.text = String(tweet!.favoritesCount + 1)
            favorited = true
        }
        else{
            TwitterClient.sharedInstance.unfavorited(tweet!.tweetID!)
            LikeButton.setBackgroundImage(UIImage(named: "favorite"), forState: .Normal)
            likeCountLabel.text = String(tweet!.favoritesCount)
            favorited = false
        }
        
        
    }
    
    
    @IBAction func onProfilePicButton(sender: AnyObject) {
        
        
        let profileViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ProfileVC") as! ProfileViewController
        
        
        
        
        profileViewController.user = tweet!.user
        self.navigationController?.pushViewController(profileViewController, animated: true)
        
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ReplyFromDetail"{
            
            let DestViewController = segue.destinationViewController as! UINavigationController
            let targetController = DestViewController.topViewController as! ReplyViewController
            
            targetController.tweet = self.tweet
            
            
        }
    }
    
    
    
    @IBAction func OnReplyButton(sender: AnyObject) {
        performSegueWithIdentifier("ReplyFromDetail", sender: nil)
    }
}