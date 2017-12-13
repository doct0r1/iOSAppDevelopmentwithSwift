//
//  LikedTableViewController.swift
//  Photowall
//
//  Created by Ali TANIRLAR on 15.08.2017.
//  Copyright © 2017 Inohive. All rights reserved.
//

import UIKit
import CoreData

class LikedTableViewController: UITableViewController {
    var likedPhotos: [NSManagedObject] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.title = "Liked Photos"
    }
    
    var urlSession: NSURLSession!
    

    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.urlSession.invalidateAndCancel()
        self.urlSession = nil
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        self.urlSession = NSURLSession(configuration: configuration)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LikedTableViewController.getLikedPhotos), name: "deletedPhoto", object: nil)
        
        getLikedPhotos()

        
    }
    
    
    func getLikedPhotos() {
        
        tableView.reloadData()
        
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let request = NSFetchRequest(entityName: "Liked")
        do {
            
            let result = try managedContext.executeFetchRequest(request)
            likedPhotos = result as! [NSManagedObject]
        } catch let error as NSError{
            print(error.localizedDescription)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.likedPhotos.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PhotoCell", forIndexPath: indexPath) as! PhotoCellTableViewCell
        
        let photo = self.likedPhotos[indexPath.row]
        cell.userNameLabel.text = photo.valueForKey("username") as? String
        
        let smallURL = NSURL(string: (photo.valueForKey("smallURL") as? String)!)
        
        let request = NSURLRequest(URL: smallURL!)
        
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
            self.performSegueWithIdentifier("ShowLikedPhoto", sender: self)
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowLikedPhoto" {
            let destinationVC = segue.destinationViewController as! PhotoDetailViewController
            let indexPath = self.tableView.indexPathForSelectedRow
            let selectedItem = likedPhotos[(indexPath?.row)!]
            destinationVC.choosenPhotoID = selectedItem.valueForKey("id") as! String
       
            
            
        }
    }
    
    
    
    
}
