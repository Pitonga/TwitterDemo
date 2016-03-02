//
//  TweetsViewController.swift
//  TwitterDemo
//
//  Created by Edwin M. Rivera on 2/21/16.
//  Copyright © 2016 CodePath Marky. All rights reserved.
//

import UIKit

class TweetsViewController:UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var tableView: UITableView!
    var tweets: [Tweet]!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        let refreshControl = UIRefreshControl()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120

        TwitterClient.sharedInstance.homeTimeline({ (tweets: [Tweet]) -> () in
            self.tweets = tweets
            
            for tweet in tweets {
                print(tweet.text)
            }
            self.tableView.reloadData()
        }, failure: {(error: NSError) -> () in
                print(error.localizedDescription)
        })
        
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogoutButton(sender: AnyObject) {
        TwitterClient.sharedInstance.logout()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let Tweets = tweets{
            return Tweets.count
        }else{
            return 0
        }
        
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetTableViewCell
        
        
        cell.tweet = tweets[indexPath.row]
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        TwitterClient.sharedInstance.homeTimeline({ (tweets : [Tweet]) -> () in
            self.tweets = tweets
            
            }, failure:{ (error: NSError) -> () in
                print(error.localizedDescription)})
        
        self.tableView.reloadData()
        refreshControl.endRefreshing()
        
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "CreateTweetSegue"{ }
        else if segue.identifier == "CurrentUserProfileSegue"{ }
            
        else if segue.identifier == "ReplyFromHome"{
            if let button = sender as? UIButton {
                if let superview = button.superview {
                    if let cell = superview.superview as? TweetTableViewCell {
                        let indexPath = tableView.indexPathForCell(cell)
                        let selectedTweet = tweets![indexPath!.row]
                        
                        print("Got the tweet")
                        print(selectedTweet.text)
                        print(selectedTweet.user?.dictionary)
                        
                        let destinationNavigationController = segue.destinationViewController as! UINavigationController
            
                    }
                }
            }
        }
            
            
        else{
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPathForCell(cell)
            let selectedTweet = tweets![indexPath!.row]
            let tweetDetailViewController = segue.destinationViewController as! TweetsDetailViewController
            
            tweetDetailViewController.tweet = selectedTweet
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    @IBAction func onProfilePicTouch(sender: AnyObject) {
        
        
        let profileViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ProfileVC") as! ProfileViewController
        
        if let button = sender as? UIButton {
            if let superview = button.superview {
                if let cell = superview.superview as? TweetTableViewCell {
                    let indexPath = tableView.indexPathForCell(cell)
                    let selectedTweet = tweets![indexPath!.row]
                    let TweetUser = selectedTweet.user
                    profileViewController.user = TweetUser
                    self.navigationController?.pushViewController(profileViewController, animated: true)
                    
                }
            }
        }
    }
    
    
    @IBAction func onTweetButton(sender: AnyObject) {
        
        performSegueWithIdentifier("CreateTweetSegue",sender:nil)
        
    }
    
    
    @IBAction func onReplyButton(sender: AnyObject) {
        
        performSegueWithIdentifier("ReplyFromHome",sender:nil)
        
    }
    
}


    


