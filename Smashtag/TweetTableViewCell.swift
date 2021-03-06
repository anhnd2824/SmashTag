//
//  TweetTableViewCell.swift
//  Smashtag
//
//  Created by miyatsu-imac on 9/26/17.
//  Copyright © 2017 miyatsu-imac. All rights reserved.
//

import UIKit
import Twitter

class TweetTableViewCell: UITableViewCell {

    @IBOutlet weak var tweetProfileImageView: UIImageView!
    @IBOutlet weak var tweetCreatedLabel: UILabel!
    @IBOutlet weak var tweetUserLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    var tweet: Twitter.Tweet?{
        didSet{
            updateUI()
        }
    }
    
    private func updateUI(){
        tweetTextLabel.text = tweet?.text
        tweetUserLabel.text = tweet?.user.description
        
        if let profileImageURL = tweet?.user.profileImageURL{
            // FIXME: blocks main thread
            if let imageData = try? Data(contentsOf: profileImageURL as URL){
                tweetProfileImageView?.image = UIImage(data: imageData)
            }
        } else {
            tweetProfileImageView?.image = nil
        }
        
        if let created = tweet?.created{
            let formatter = DateFormatter()
            if Date().timeIntervalSince(created as Date) > 24*60*60 {
                formatter.dateStyle = .short
            } else {
                formatter.timeStyle = .short
            }
            tweetCreatedLabel?.text = formatter.string(from: created as Date)
        } else {
            tweetCreatedLabel?.text = nil
        }
    }
}
