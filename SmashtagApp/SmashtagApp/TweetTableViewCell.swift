//
//  TweetTableViewCell.swift
//  SmashtagApp
//
//  Created by sukhjeet singh sandhu on 23/06/16.
//  Copyright © 2016 sukhjeet singh sandhu. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {

    var tweet: Tweet? {
        didSet {
            updateUI()
        }
    }

    private let tweetProfileImageView: UIImageView =  {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIImageView())

    private let tweetScreenNameLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .whiteColor()
        return $0
    }(UILabel())

    private let tweetTextLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.numberOfLines = 0
        $0.textColor = .whiteColor()
        return $0
    }(UILabel())

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor(red: 59/255, green: 63/255, blue: 64/255, alpha: 1)
        addTweetProfileImageView()
        addTweetScreenNameLabel()
        addTweetTextLabel()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addTweetProfileImageView() {
        self.addSubview(tweetProfileImageView)
        self.addConstraint(NSLayoutConstraint(item: tweetProfileImageView, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1.0, constant: 8.0))
        self.addConstraint(NSLayoutConstraint(item: tweetProfileImageView, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier: 1.0, constant: 8.0))
        self.addConstraint(NSLayoutConstraint(item: tweetProfileImageView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 48.0))
        self.addConstraint(NSLayoutConstraint(item: tweetProfileImageView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 48.0))
    }

    private func addTweetScreenNameLabel() {
        self.addSubview(tweetScreenNameLabel)
        self.addConstraint(NSLayoutConstraint(item: tweetScreenNameLabel, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: tweetScreenNameLabel, attribute: .Leading, relatedBy: .Equal, toItem: tweetProfileImageView, attribute: .Trailing, multiplier: 1.0, constant: 8.0))
        self.addConstraint(NSLayoutConstraint(item: tweetScreenNameLabel, attribute: .Trailing, relatedBy: .Equal, toItem: self, attribute: .Trailing, multiplier: 1.0, constant: -8.0))
    }

    private func addTweetTextLabel() {
        self.addSubview(tweetTextLabel)
        self.addConstraint(NSLayoutConstraint(item: tweetTextLabel, attribute: .Top, relatedBy: .Equal, toItem: tweetScreenNameLabel, attribute: .Bottom, multiplier: 1.0, constant: 8.0))
        self.addConstraint(NSLayoutConstraint(item: tweetTextLabel, attribute: .Leading, relatedBy: .Equal, toItem: tweetProfileImageView, attribute: .Trailing, multiplier: 1.0, constant: 8.0))
        self.addConstraint(NSLayoutConstraint(item: tweetTextLabel, attribute: .Trailing, relatedBy: .Equal, toItem: self, attribute: .Trailing, multiplier: 1.0, constant: -8.0))
        self.addConstraint(NSLayoutConstraint(item: tweetTextLabel, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: -8.0))
    }

    private func updateUI() {
        tweetTextLabel.attributedText = nil
        tweetScreenNameLabel.text = nil
        tweetProfileImageView.image = nil

        if let tweet = self.tweet {
            tweetTextLabel.text = tweet.text
            if tweetTextLabel.text != nil {
                for _ in tweet.media {
                    tweetTextLabel.text! += " 📷"
                }
            }
            tweetScreenNameLabel.text = "\(tweet.user)"
            if let profileImageUrl = tweet.user.profileImageURL {
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    if let imageData = NSData(contentsOfURL: profileImageUrl) {
                        self.tweetProfileImageView.image = UIImage(data: imageData)
                    }
                }
            }
        }
    }
}
