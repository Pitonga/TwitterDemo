//
//  TweetTableViewCell.swift
//  TwitterDemo
//
//  Created by Edwin M. Rivera on 2/21/16.
//  Copyright © 2016 CodePath Marky. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {
    var tweet: Tweet!
    var user: User! {
        didSet{
            usernameLabel.text = user.name as? String
            profileView.setImageWithURL(user.profileUrl!)
            accountIDLabel.text = user.screenname as? String
            timeLabel.text = tweet.timestampString
            tweetLabel.text = tweet.text as? String
           
            
            
            
            
            
            
            
        }
    }
    
   
    @IBOutlet weak var profileView: UIImageView!

   
    @IBOutlet weak var favoriteView: UIImageView!
    @IBOutlet weak var retweetView: UIImageView!
    @IBOutlet weak var replyView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var accountIDLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        profileView.layer.cornerRadius = 10
        favoriteView.image = UIImage(named: "favorite")
        replyView.image = UIImage(named: "reply")
        retweetView.image = UIImage(named: "retweet")
        
        }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
