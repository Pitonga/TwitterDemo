//
//  ReplyViewController.swift
//  TwitterDemo
//
//  Created by Edwin M. Rivera on 3/1/16.
//  Copyright © 2016 CodePath Marky. All rights reserved.
//

import UIKit

class ReplyViewController: UIViewController,UITextViewDelegate {
    
    
    @IBOutlet weak var CancelReply: UIButton!
    @IBOutlet weak var SendReply: UIButton!
    @IBOutlet weak var UserName: UILabel!
    
    @IBOutlet weak var CounterLabel: UILabel!
    
    @IBOutlet weak var TweetText: UITextView!
    
    var user: User!
    var charCountVar: Int = 0
    var status: String?
    var idOftweetToReply: String?
    var tweet: Tweet?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\(tweet!.text)")
        print("\(tweet?.tweetID)")
        TweetText.delegate = self
        UserName.text = User.currentUser?.name as String!
        TweetText.becomeFirstResponder()
        
        
        
        // Do any additional setup after loading the view.
    }
    
    func textViewDidChange(textView: UITextView){
        
        
        charCountVar = TweetText.text.characters.count as Int
        let totalChars = 140 - charCountVar
        CounterLabel.text = "\(totalChars)"
        if (140 - totalChars) < 0 {
            CounterLabel.tintColor = UIColor.redColor()
        } else {
            CounterLabel.tintColor = UIColor.grayColor()
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onCancelButton(sender: AnyObject) {
        dismissViewControllerAnimated(true,completion: nil)
        
    }
    
    @IBAction func onSendReply(sender: AnyObject) {
        
        let CompleteTweetText = "@\(tweet!.user!.screenname) \(TweetText.text)"
        TwitterClient.sharedInstance.reply((tweet!.tweetID)!,tweetText: CompleteTweetText)
    }
}
