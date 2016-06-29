//
//  User.swift
//  SmashtagApp
//
//  Created by sukhjeet singh sandhu on 23/06/16.
//  Copyright © 2016 sukhjeet singh sandhu. All rights reserved.
//

import Foundation

public struct User: CustomStringConvertible
{
    public var screenName: String
    public var name: String
    public var profileImageURL: NSURL?
    public var id: String!
    
    public var description: String { return "@\(screenName) (\(name))" }
    
    init?(data: NSDictionary?) {
        let name = data?.valueForKeyPath("name") as? String
        let screenName = data?.valueForKeyPath("screen_name") as? String
        if name != nil && screenName != nil {
            self.name = name!
            self.screenName = screenName!
            self.id = data?.valueForKeyPath("id_str") as? String
            if let urlString = data?.valueForKeyPath("profile_image_url") as? String {
                self.profileImageURL = NSURL(string: urlString)
            }
        } else {
            return nil
        }
    }
    
    init() {
        screenName = "Unknown"
        name = "Unknown"
    }
}
