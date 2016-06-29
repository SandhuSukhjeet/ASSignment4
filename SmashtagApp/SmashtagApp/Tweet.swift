//
//  Tweet.swift
//  SmashtagApp
//
//  Created by sukhjeet singh sandhu on 23/06/16.
//  Copyright © 2016 sukhjeet singh sandhu. All rights reserved.
//

import Foundation

public class Tweet : CustomStringConvertible
{
    public var text: String
    public var user: User
    public var media = [MediaItem]()
    public var hashtags = [String]()
    public var urls = [String]()
    public var userMentions = [String]()
    
    init?(data: NSDictionary?) {
        if let user = User(data: data?.valueForKeyPath("user") as? NSDictionary) {
            self.user = user
            if let text = data?.valueForKeyPath("text") as? String {
                self.text = text
                if let mediaEntities = data?.valueForKeyPath("entities.media") as? NSArray {
                    for mediaData in mediaEntities {
                        if let mediaItem = MediaItem(data: mediaData as? NSDictionary) {
                            media.append(mediaItem)
                        }
                    }
                }
                let hashtagMentionsArray = data?.valueForKeyPath("entities.hashtags") as? NSArray
                for data in hashtagMentionsArray! {
                    if let hashtagdata = data as? NSDictionary {
                        if let hashtagString = hashtagdata.valueForKey("text") as? String {
                            hashtags.append(hashtagString)
                        }
                    }
                }
                let urlMentionsArray = data?.valueForKeyPath("entities.urls") as? NSArray
                for data in urlMentionsArray! {
                    if let urlData = data as? NSDictionary {
                        if let urlString = urlData.valueForKey("url") as? String {
                            urls.append(urlString)
                        }
                    }
                }
                let userMentionsArray = data?.valueForKeyPath("entities.user_mentions") as? NSArray
                for data in userMentionsArray! {
                    if let userMentionData = data as? NSDictionary {
                        if let userString = userMentionData.valueForKey("screen_name") as? String {
                            userMentions.append(userString)
                        }
                    }
                }
                return
            }
        }
        self.text = ""
        self.user = User()
        return nil
    }
    
    public var description: String { return "\(user) - \n\(text)\nhashtags: \(hashtags)\nurls: \(urls)\nuser_mentions: \(userMentions)"  }
}
