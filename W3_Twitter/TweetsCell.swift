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
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
