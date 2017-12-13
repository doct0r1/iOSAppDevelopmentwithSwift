//
//  Feed.swift
//  Photowall
//
//  Created by Ali TANIRLAR on 9.08.2017.
//  Copyright © 2017 Inohive. All rights reserved.
//

import Foundation

class Feed {
    let photos: [Photo]
    let sourceURL: NSURL
    
    init(photos newPhotos: [Photo], sourceURL newURL: NSURL) {
        self.photos = newPhotos
        self.sourceURL = newURL
    }
    
    convenience init? (data: NSData, sourceURL url: NSURL) {
        
        var newPhotos = [Photo]()
        
        var jsonObject: Array<AnyObject>?
        
        do {
            jsonObject = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: 0)) as? Array<AnyObject>
        } catch {
            
        }
        
        guard let itemArray = jsonObject else {
            return nil
        }
        
        for item in itemArray {
            guard let itemDict = item as? Dictionary<String,AnyObject> else { continue }
            
            guard let itemID = itemDict["id"] as? String else { continue }
            
            guard let itemUserDict = itemDict["user"] as? Dictionary<String,AnyObject> else { continue }
            
            guard let userName = itemUserDict["name"] as? String else { continue}
            
            guard let userProfileImageDict = itemUserDict["profile_image"] as? Dictionary<String,AnyObject> else { continue}
            guard let userProfileImage = userProfileImageDict["small"] as? String else { continue }
            
            guard let imageUrls = itemDict["urls"] as? Dictionary<String,AnyObject> else { continue }
            
            guard let smallImageString = imageUrls["small"] as? String else { continue }
            
            guard let regularImageString = imageUrls["regular"] as? String else { continue }
            
            guard let userProfileImageURL = NSURL(string: userProfileImage) else { continue }
            
            guard let smallImageURL = NSURL(string: smallImageString) else {continue}
            
            guard let regularImageURL = NSURL(string: regularImageString) else {continue}

            
            newPhotos.append(Photo(id: itemID, name: userName, profileImageURL: userProfileImageURL, imageSmallURL: smallImageURL , imageRegularURL: regularImageURL))
        }
        
        self.init(photos: newPhotos, sourceURL:url )
    }
    
 
}
