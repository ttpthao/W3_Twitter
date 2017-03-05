//
//  TweetsCell.swift
//  W3_Twitter
//
//  Created by Phuong Thao Tran on 3/4/17.
//  Copyright © 2017 Phuong Thao Tran. All rights reserved.
//

import UIKit
import AFNetworking

class TweetsCell: UITableViewCell {
    
    @IBOutlet weak var avaImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var tweet: Tweet! {
        didSet{
            nameLabel.text = tweet.user?.name
            nameLabel.sizeToFit()
            usernameLabel.text = "@\(tweet.user!.screenName!)"
            usernameLabel.sizeToFit()
            timeLabel.text = tweet.timeSinceCreated
            contentLabel.text = tweet.text
            if let url = tweet.user?.profileImageUrl {
                avaImage.setImageWith(url)
            }
            favorite()
            retweet()
        }
    }
    
    @IBAction func onRetweet(_ sender: UIButton) {
        if tweet.isRetweeted {
            TwitterClient.sharedInstance?.unRetweet(id: tweet.id as! Int, success: {
                self.tweet.retweetCount = self.tweet.retweetCount! - 1
                self.retweetCountLabel.text = "\(Int(self.tweet.retweetCount!))"
                self.retweetCountLabel.textColor = UIColor.gray
                self.tweet.isRetweeted = !self.tweet.isRetweeted
                self.retweetButton.setImage(UIImage(named: "retweet"), for: .normal)
            }, failure: { (error: NSError) in
                print(error.localizedDescription)
            })
        }
        else {
            TwitterClient.sharedInstance?.retweet(id: tweet.id as! Int, success: {
                self.tweet.retweetCount = self.tweet.retweetCount! + 1
                self.retweetCountLabel.text = "\(Int(self.tweet.retweetCount!))"
                self.retweetCountLabel.textColor = UIColor.red
                self.tweet.isRetweeted = !self.tweet.isRetweeted
                self.retweetButton.setImage(UIImage(named: "retweet_on"), for: .normal)
            }, failure: { (error: NSError) in
                print(error.localizedDescription)
            })
        }
    }
    
    @IBAction func onFavorite(_ sender: UIButton) {
        if tweet.isFavorited {
            TwitterClient.sharedInstance?.unFavoriteTweet(id: tweet.id as! Int, success: {
                self.tweet.favoriteCount = self.tweet.favoriteCount! - 1
                self.favoriteCountLabel.text = "\(Int(self.tweet.favoriteCount!))"
                self.favoriteCountLabel.textColor = UIColor.gray
                self.tweet.isFavorited = !self.tweet.isFavorited
                self.favoriteButton.setImage(UIImage(named: "favorite"), for: .normal)
                
            }, failure: { (error: NSError) in
                print(error.localizedDescription)
            })
        }
        else{
            TwitterClient.sharedInstance?.favoriteTweet(id: tweet.id as! Int, success: {
                self.tweet.favoriteCount = self.tweet.favoriteCount! + 1
                self.favoriteCountLabel.text = "\(Int(self.tweet.favoriteCount!))"
                self.favoriteCountLabel.textColor = UIColor.red
                self.tweet.isFavorited = !self.tweet.isFavorited
                self.favoriteButton.setImage(UIImage(named: "favorite_on"), for: .normal)
            }, failure: { (error: NSError) in
                print(error.localizedDescription)
            })
        }
    }
    
    func favorite() {
        self.favoriteCountLabel.text = "\(Int(self.tweet.favoriteCount!))"
        if tweet.isFavorited {
            favoriteButton.setImage(UIImage(named: "favorite_on"), for: .normal)
            favoriteCountLabel.textColor = UIColor.red
        }
        else {
            favoriteButton.setImage(UIImage(named: "favorite"), for: .normal)
            favoriteCountLabel.textColor = UIColor.gray
        }
    }
    
    func retweet() {
        self.retweetCountLabel.text = "\(Int(self.tweet.retweetCount!))"
        if tweet.isRetweeted {
            retweetButton.setImage(UIImage(named: "retweet_on"), for: .normal)
            retweetCountLabel.textColor = UIColor.red
        }
        else{
            retweetButton.setImage(UIImage(named: "retweet"), for: .normal)
            retweetCountLabel.textColor = UIColor.gray
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
