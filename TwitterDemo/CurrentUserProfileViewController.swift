//
//  CurrentUserProfileViewController.swift
//  TwitterDemo
//
//  Created by Edwin M. Rivera on 3/1/16.
//  Copyright © 2016 CodePath Marky. All rights reserved.
//

import UIKit

class CurrentUserProfileViewController: UIViewController, UITableViewDelegate,
UITableViewDataSource {
    
    @IBOutlet weak var BannerImage: UIImageView!
    
    @IBOutlet weak var ProfileImage: UIImageView!
    
    @IBOutlet weak var UserNameLabel: UILabel!
    
    @IBOutlet weak var AcoountIdLabel: UILabel!
    
    @IBOutlet weak var BioLabel: UILabel!
    
    @IBOutlet weak var FollowingCountLabel: UILabel!
    
    @IBOutlet weak var FollowersCountLabebl: UILabel!
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var tweets: [Tweet]?
    var user = User._currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
      tableView.dataSource = self
      tableView.delegate = self
        //tableView.rowHeight = UITableViewAutomaticDimension
       // tableView.estimatedRowHeight = 120
        
        TwitterClient.sharedInstance.UserTimeLine(user!.UserId!)(success: { (tweets : [Tweet]) -> ()
            in
            
            self.tweets = tweets
            print("Success getting timeline")
            
           self.tableView.reloadData()
            
            
            }, failure:{ (error: NSError) -> () in
                print(error.localizedDescription)
                print("Failed getting the timeline")}
        )
        
        UserNameLabel.text = user!.name as String!
        ProfileImage.setImageWithURL((user?.profileUrl)!)
        BannerImage.setImageWithURL(user!.bannerImage!)
        let UserName = user!.screenname as! String
        AcoountIdLabel.text =  "@\(UserName)"
        BioLabel.text = user!.biography as? String
        FollowingCountLabel.text = user!.FollowingCountString as String
        FollowersCountLabebl.text = user!.FollowersCountString as String
        
        
        
        // Do any additional setup after loading the view.
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)}
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if let Tweets = tweets{
            
            return Tweets.count
        }
            
        else{
            print("No Tweets")
            return 0
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CurrentUserTweetCell") as! TweetTableViewCell
        
        cell.tweet = tweets![indexPath.row]
        
        return cell
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "ReplyFromCurrentUser"{
        }
        else{
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPathForCell(cell)
            
            let selectedTweet = tweets![indexPath!.row]
            
            let tweetDetailViewController = segue.destinationViewController as! TweetsDetailViewController
            
            tweetDetailViewController.tweet = selectedTweet
        }
    }
    
    
    
    
    @IBAction func OnReplyButton(sender: AnyObject) {
        
        performSegueWithIdentifier("ReplyFromCurrentUser", sender: nil)
        
    }
}