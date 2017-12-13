//
//  TagsTableViewController.swift
//  PhotoFeed
//
//  Created by Dmitriy Barash on 10/15/2017

import UIKit
import CoreData


class TagsTableViewController: UITableViewController {

    var feed: Feed? {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var fetchedResultsController: NSFetchedResultsController!
    
    override func viewWillAppear(animated: Bool) {
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            fatalError("tags fetch failed")
        }
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return self.fetchedResultsController.sections!.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.fetchedResultsController.sections![section].numberOfObjects
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tagCell", forIndexPath: indexPath)
        let tag = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Tag
        
        cell.textLabel?.text = tag.title
        
        
        
        return cell
    }
    
//    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//        if editingStyle == UITableViewCellEditingStyle.Delete {
//            let tag = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Tag
//            
//            print(tag.title)     }
//    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showImages" {
            let indexPath = self.tableView.indexPathForSelectedRow!
            let destination = segue.destinationViewController as! ImageFeedTableViewController
            
            let tag = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Tag
            if let images = tag.images?.allObjects as? [Image] {
                var feedItems = [FeedItem]()
                for image in images {
                    let imageURL = NSURL(string: image.imageURL ?? "") ?? NSURL()
                    
                    let newFeedItem = FeedItem(title: image.title ?? "(no title)" , imageURL: imageURL)
                    feedItems.append(newFeedItem)
                    
                }
                let feed = Feed(items: feedItems, sourceURL: NSURL())
                destination.feed = feed
                destination.lastView = true
                
            }
            
            
        }
    }

}
