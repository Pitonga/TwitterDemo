//
//  CreateTweetViewController.swift
//  TwitterDemo
//
//  Created by Edwin M. Rivera on 3/1/16.
//  Copyright © 2016 CodePath Marky. All rights reserved.
//

import UIKit

class CreateTweetViewController: UIViewController, UITextViewDelegate
{
    
    @IBOutlet weak var whatsHappeningLabel: UILabel!
    @IBOutlet weak var tweetText: UITextView!
    @IBOutlet weak var tweetButton: UIButton!
    @IBOutlet weak var UserNameLabel: UILabel!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var charCount: UILabel!
    
    
    var user: User!
    var charCountVar: Int = 0
    var status: String?
    var idOftweetToReply: String?
    var UserToReplytweet: Tweet?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tweetText.delegate = self
        UserNameLabel.text = User.currentUser?.name as String!
        tweetText.becomeFirstResponder()
        whatsHappeningLabel.text = "What's happening?"
        
    }
    
    
    func textViewDidChange(textView: UITextView){
        
        whatsHappeningLabel.text = ""
        charCountVar = tweetText.text.characters.count as Int
        let totalChars = 140 - charCountVar
        charCount.text = "\(totalChars)"
        if (140 - totalChars) < 0 {
            charCount.tintColor = UIColor.redColor()
        } else {
            charCount.tintColor = UIColor.grayColor()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
    
    @IBAction func OnTweetButton(sender: AnyObject) {
        
        let charCount = tweetText.text.characters.count
        
        if charCount <= 140 {
            TwitterClient.sharedInstance.SendTweet(tweetText.text)
            
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    
    
    @IBAction func onCancelButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
}
