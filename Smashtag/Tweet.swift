//
//  Tweet.swift
//  Smashtag
//
//  Created by miyatsu-imac on 9/28/17.
//  Copyright © 2017 miyatsu-imac. All rights reserved.
//

import UIKit
import CoreData
import Twitter

class Tweet: NSManagedObject {
    class func findOrCreateTweet(matching twitterInfo: Twitter.Tweet, in context: NSManagedObjectContext) throws -> Tweet{
        let request: NSFetchRequest<Tweet> = Tweet.fetchRequest()
        request.predicate = NSPredicate(format: "unique = %@", twitterInfo.id)
        
        do {
            let matches = try context.fetch(request)
            if matches.count > 0{
                assert(matches.count == 1, "Tweet.findOrCreateTweet -- database inconsistency")
                return matches[0]
            }
        } catch {
            throw error
        }
        
        let tweet = Tweet(context: context)
        tweet.unique = twitterInfo.id
        tweet.text = twitterInfo.text
        tweet.created = twitterInfo.created as Date
        tweet.tweeter = try? TwitterUser.findOrCreateTwitterUser(matching: twitterInfo.user, in: context)
        return tweet
    }
}
