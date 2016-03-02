//
//  ProfileViewController.swift
//  TwitterDemo
//
//  Created by Edwin M. Rivera on 3/1/16.
//  Copyright © 2016 CodePath Marky. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var bannerImage: UIImageView!
    @IBOutlet weak var profileView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var accountIDLabel: UILabel!
    @IBOutlet weak var userBioLabel: UILabel!
    @IBOutlet weak var followingCount: UILabel!
    @IBOutlet weak var followersCount: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var tweets: [Tweet]?
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        let refreshControl = UIRefreshControl()
        
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: scrollView.frame.origin.y + tableView.frame.size.height)
        
        
        
        
        
        
        
        TwitterClient.sharedInstance.RetrieveUser(user!.UserId!)(success: { (user : User) -> ()
            in
            self.user = user
            
            }, failure:{ (error: NSError) -> () in
                print(error.localizedDescription)}
        )
        
        TwitterClient.sharedInstance.UserTimeLine(user!.UserId!)(success: { (tweets : [Tweet]) -> ()
            in
            
            self.tweets = tweets
            print("Success getting timeline")
            
            self.tableView.reloadData()
            
            
            }, failure:{ (error: NSError) -> () in
                print(error.localizedDescription)
                print("Timeline Failed")}
        )
        
        print("Profile VC")
        
        userNameLabel.text = user!.name as String!
        profileView.setImageWithURL(user!.profileUrl!)
        bannerImage.setImageWithURL(user!.bannerImage!)
        let UserName = user!.screenname as! String
        accountIDLabel.text =  "@\(UserName)"
        userBioLabel.text = user!.biography as? String
        followingCount.text = user!.FollowingCountString as String
        followersCount.text = user!.FollowersCountString as String
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        tableView.reloadData()
        
        
        // Do any additional setup after loading the view.
        
        
    }
    
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
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ProfileTweetCell") as! TweetTableViewCell
        
        cell.tweet = tweets![indexPath.row]
        
        return cell
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        
        // ... Create the NSURLRequest (myRequest) ...
        TwitterClient.sharedInstance.UserTimeLine(user!.UserId!)(success: { (tweets : [Tweet]) -> ()
            in
            
            self.tweets = tweets
            
            }, failure:{ (error: NSError) -> () in
                print(error.localizedDescription)}
        )
        
        self.tableView.reloadData()
        refreshControl.endRefreshing()
        
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        if segue.identifier == "TweetDetailSegue" {
            
            
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPathForCell(cell)
            
            let selectedTweet = tweets![indexPath!.row]
            
            let tweetDetailViewController = segue.destinationViewController as! TweetsDetailViewController
            
            tweetDetailViewController.tweet = selectedTweet
        }
        
        if segue.identifier == "ReplyFromProfile" {
            
        }
    }
    
    
    
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    
    
}