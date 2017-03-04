//
//  DetailsViewController.swift
//  W3_Twitter
//
//  Created by Phuong Thao Tran on 3/4/17.
//  Copyright © 2017 Phuong Thao Tran. All rights reserved.
//

import UIKit
import AFNetworking

class DetailsViewController: UIViewController {

    @IBOutlet weak var retweetIcon: UIImageView!
    @IBOutlet weak var retweetedLabel: UILabel!
    @IBOutlet weak var avaImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    
    @IBOutlet weak var retweetIconHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var retweetedHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    
    var tweet: Tweet!
    var indexPath: NSIndexPath?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        avaImage.layer.cornerRadius = 8
        avaImage.layer.masksToBounds = true
        
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        
        setDetailsContent()
    }
    
    func setDetailsContent(){
        nameLabel.text = tweet.user?.name
        if let screenName = tweet.user?.screenName {
            usernameLabel.text = "@\(screenName)"
        }
        contentLabel.text = tweet.text
        avaImage.setImageWith((tweet.user?.profileImageUrl)!)
        timeLabel.text = tweet.formatedDetailDate()
        
        if let tweetCount = tweet.retweetCount {
            if tweetCount > 0 {
                retweetCountLabel.text = "\(tweetCount)"
            } else {
                retweetCountLabel.text = ""
            }
        }
        
        if let favoriteCount = tweet.favoriteCount {
            if favoriteCount > 0 {
                favoriteCountLabel.text = "\(favoriteCount)"
            } else {
                favoriteCountLabel.text = ""
            }
        }
        
        // Set suitable icons for retweet button and favorite button
        if tweet.isRetweeted {
            retweetButton.setImage(UIImage(named: "retweet_on"), for: .normal)
        } else {
            retweetButton.setImage(UIImage(named: "retweet"), for: .normal)
        }
        
        if tweet.isFavorited {
            favoriteButton.setImage(UIImage(named: "favorite_on"), for: .normal)
        } else {
            favoriteButton.setImage(UIImage(named: "favorite"), for: .normal)
        }
        
        // Disable retweet button if this is current user's tweet
        if let currentUser = User.currentUser {
            if tweet.user?.screenName == currentUser.screenName {
                retweetButton.isEnabled = false
            } else {
                retweetButton.isEnabled = true
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onBack(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
