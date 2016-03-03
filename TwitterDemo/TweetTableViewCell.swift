//
//  TweetTableViewCell.swift
//  TwitterDemo
//
//  Created by Edwin M. Rivera on 2/21/16.
//  Copyright © 2016 CodePath Marky. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {
    
    @IBOutlet weak var favoriteCountLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var profileView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var accountIDLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var replyButton: UIButton!

    var tweet: Tweet!{
        didSet{
            usernameLabel.text = tweet.user?.name
            profileView.setImageWithURL((tweet.user?.profileUrl)!)
            accountIDLabel.text = "@\((tweet.user?.screenname)!)"
            timeLabel.text = tweet.timestampString
            tweetLabel.text = tweet.text as? String
            retweetCountLabel.text = String(tweet.retweetCount)
            favoriteCountLabel.text = String(tweet.favoritesCount)
        }
    }
    
    var favorited = false
    var retweeted = false
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileView.layer.cornerRadius = 10
        profileView.clipsToBounds = true
        retweetButton.setBackgroundImage(UIImage(named: "retweet"), forState: .Normal)
        favoriteButton.setBackgroundImage(UIImage(named: "favorite"), forState: .Normal)
        replyButton.setBackgroundImage(UIImage(named: "reply"), forState: .Normal)
        tweetLabel.sizeToFit()
        }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func retweet(sender: AnyObject) {
        if !retweeted {
            TwitterClient.sharedInstance.retweet(tweet.tweetID!)
            retweetButton.setBackgroundImage(UIImage(named: "retweeted"), forState: .Normal)
            retweetCountLabel.text = String(tweet.retweetCount + 1)
            retweeted = true
        }
        else{
            TwitterClient.sharedInstance.unretweet(tweet.tweetID!)
            retweetButton.setBackgroundImage(UIImage(named: "retweet"), forState: .Normal)
            retweetCountLabel.text = String(tweet.retweetCount)
            retweeted = false
            
        }
    }
    
    @IBAction func favorite(sender: AnyObject) {
        if !favorited {
            TwitterClient.sharedInstance.favorited(tweet.tweetID!)
            favoriteButton.setBackgroundImage(UIImage(named: "favorited"), forState: .Normal)
            favoriteCountLabel.text = String(tweet.favoritesCount + 1)
            favorited = true
        }
        else{
            TwitterClient.sharedInstance.unfavorited(tweet.tweetID!)
            favoriteButton.setBackgroundImage(UIImage(named: "favorite"), forState: .Normal)
            favoriteCountLabel.text = String(tweet.favoritesCount)
            favorited = false
        }

    
    }

}
