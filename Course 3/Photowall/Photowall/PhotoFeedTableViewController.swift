//
//  ImageFeedTableViewController.swift
//  Photowall
//
//  Created by Ali TANIRLAR on 9.08.2017.
//  Copyright © 2017 Inohive. All rights reserved.
//

import UIKit

class PhotoFeedTableViewController: UITableViewController {
    
    
    var feed: Feed? {
        didSet {
            self.tableView.reloadData()
            
        }
    }
    
    var urlSession: NSURLSession!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        self.urlSession = NSURLSession(configuration: configuration)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.urlSession.invalidateAndCancel()
        self.urlSession = nil
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "New Photos"

    }

  

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.feed?.photos.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PhotoCell", forIndexPath: indexPath) as! PhotoCellTableViewCell
        
        let photo = self.feed!.photos[indexPath.row]
        cell.userNameLabel.text = photo.name
        
        
        let request = NSURLRequest(URL: photo.imageSmallURL)
        
        cell.dataTask = self.urlSession.dataTaskWithRequest(request) { (data, response, error) -> Void in
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                if error == nil && data != nil {
                    let image = UIImage(data: data!)
                    cell.photoSmallImageView.image = image
                }
            })
            
        }
        
        cell.dataTask?.resume()
        
        return cell
    }
    override func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = cell as? PhotoCellTableViewCell {
            cell.dataTask?.cancel()
        }
    }

    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        _ = tableView.indexPathForSelectedRow!
        if let _ = tableView.cellForRowAtIndexPath(indexPath) {
            self.performSegueWithIdentifier("ShowPhoto", sender: self)
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowPhoto" {
            let destinationVC = segue.destinationViewController as! PhotoDetailViewController
            let indexPath = self.tableView.indexPathForSelectedRow
            destinationVC.photo = self.feed?.photos[(indexPath?.row)!]
            
        }
    }
    
}
