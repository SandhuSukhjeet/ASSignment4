//
//  TwitterRequest.swift
//  SmashtagApp
//
//  Created by sukhjeet singh sandhu on 23/06/16.
//  Copyright © 2016 sukhjeet singh sandhu. All rights reserved.
//

import Foundation
import Social
import Accounts

public class TwitterRequest
{
    var twitterAccount: ACAccount?
    public var requestType: String
    public var parameters = Dictionary<String, String>()
    
    public init(_ requestType: String, _ parameters: Dictionary<String, String> = [:]) {
        self.requestType = requestType
        self.parameters = parameters
    }
    
    public convenience init(search: String, count: Int = 0) {
        var parameters = ["q" : search]
        if count > 0 {
            parameters["count"] = "\(count)"
        }
        self.init("search/tweets", parameters)
    }
    
    
    func performTwitterRequest(method: SLRequestMethod, handler: (AnyObject?) -> Void) {
        let request = SLRequest(
            forServiceType: SLServiceTypeTwitter,
            requestMethod: method,
            URL: NSURL(string: "https://api.twitter.com/1.1/\(requestType).json"),
            parameters: self.parameters
        )
        performTwitterRequest(request, handler: handler)
    }
    
    func performTwitterRequest(request: SLRequest, handler: (AnyObject?) -> Void) {
        if let account = twitterAccount {
            request.account = account
            request.performRequestWithHandler { (data, urlResponse, _) in
                var jsonObject: AnyObject?
                do {
                    if data != nil {
                        jsonObject = try NSJSONSerialization.JSONObjectWithData(data,options: NSJSONReadingOptions.MutableLeaves)
                    }
                } catch let error as NSError {
                    print(error)
                }
                handler(jsonObject)
            }
        }
        else {
            let accountStore = ACAccountStore()
            let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
            accountStore.requestAccessToAccountsWithType(accountType, options: nil) { (granted, _) in
                if granted {
                    if let account = accountStore.accountsWithAccountType(accountType).last as? ACAccount {
                        self.twitterAccount = account
                        self.performTwitterRequest(request, handler: handler)
                    }
                    else {
                        let error = "Couldn't discover twitter account type"
                        handler(error)
                    }
                }
                else {
                    let error = "Access to twitter was not granted"
                    handler(error)
                }
            }
        }
    }
    
    public func fetchTweets(handler: ([Tweet]) -> Void) {
        fetch { results in
            var tweets = [Tweet]()
            var tweetArray: NSArray?
            if let dictionary = results as? NSDictionary {
                if let tweets = dictionary["statuses"] as? NSArray {
                    tweetArray = tweets
                } else if let tweet = Tweet(data: dictionary) {
                    tweets = [tweet]
                }
            } else if let array = results as? NSArray {
                tweetArray = array
            }
            if tweetArray != nil {
                for tweetData in tweetArray! {
                    if let tweet = Tweet(data: tweetData as? NSDictionary) {
                        tweets.append(tweet)
                    }
                }
            }
            handler(tweets)
        }
    }
    
    public func fetch(handler: (results: AnyObject?) -> Void) {
        performTwitterRequest(SLRequestMethod.GET, handler: handler)
    }
}
