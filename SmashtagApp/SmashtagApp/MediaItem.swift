//
//  MediaItem.swift
//  SmashtagApp
//
//  Created by sukhjeet singh sandhu on 23/06/16.
//  Copyright © 2016 sukhjeet singh sandhu. All rights reserved.
//

import Foundation

public struct MediaItem
{
    public var url: NSURL!
    
    init?(data: NSDictionary?) {
        if let urlString = data?.valueForKeyPath("media_url_https") as? NSString {
            if let url = NSURL(string: urlString as String) {
                self.url = url
            }
        }
        else {
            return nil
        }
    }
}
