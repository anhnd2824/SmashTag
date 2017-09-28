//
//  SmashTweetTableViewController.swift
//  Smashtag
//
//  Created by miyatsu-imac on 9/28/17.
//  Copyright © 2017 miyatsu-imac. All rights reserved.
//

import UIKit
import CoreData
import Twitter

class SmashTweetTableViewController: TweetTableViewController {
    
    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    override func insertTweets(_ newTweets: [Twitter.Tweet]) {
        super.insertTweets(newTweets)
        updateDatabase(with: newTweets)
    }
    
    private func updateDatabase(with tweets: [Twitter.Tweet]){
        container?.performBackgroundTask{ [weak self] context in
            for twitterInfo in tweets{
                // add Tweet
                _ = try? Tweet.findOrCreateTweet(matching: twitterInfo, in: context)
            }
            try? context.save()
            self?.printDatabaseStatistics()
        }
        
    }
    
    private func printDatabaseStatistics(){
        if let context = container?.viewContext{
            context.perform {
                let request: NSFetchRequest<Tweet> = Tweet.fetchRequest()
                if let tweetCount = (try? context.fetch(request))?.count{
                    print("\(tweetCount) tweets")
                }
                if let tweetCount = try? context.count(for: TwitterUser.fetchRequest()){
                    print("\(tweetCount) Twitter users")
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Tweeters Mentioning Search Term"{
            if let tweetersTVC = segue.destination as? SmashTweetersTableViewController{
                tweetersTVC.mention = searchText
                tweetersTVC.container = container
            }
        }
    }
}
