//
//  PhotoDetailViewController.swift
//  Photowall
//
//  Created by Ali TANIRLAR on 9.08.2017.
//  Copyright © 2017 Inohive. All rights reserved.
//

import UIKit
import CoreData

class PhotoDetailViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var detailImageView: UIImageView!
    
    var likeIcon: UIImage! = nil
    var dislikeIcon: UIImage! = nil
    
    
    var choosenPhotoID = ""
    
    var photo: Photo!
    
    
    
    var urlSession: NSURLSession!
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if choosenPhotoID == "" {
            loadPhoto(photo.imageRegularURL)
            self.title = photo.name
        } else {
            
            let imageURL = getChoosenPhotoURL(choosenPhotoID)
            loadPhoto(imageURL)
        }
        
        
    }
    
    func getChoosenPhotoURL(id:String) -> NSURL {
        var regularURLString:String!
        var imageRegularURL: NSURL!
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let request = NSFetchRequest(entityName: "Liked")
        request.predicate = NSPredicate(format: "id = %@", id)
        do {
            
            let results = try managedContext.executeFetchRequest(request)
            if results.count > 0 {
                for result in results {
                    if let regularURL = result.valueForKey("regularURL") {
                        regularURLString = regularURL as! String
                    }
                }
            }
            
        } catch let error  {
            print(error)
        }
        
        imageRegularURL = NSURL(string: regularURLString)!
        return imageRegularURL
        
    }
    
    func loadPhoto(imageURL: NSURL) {
        
        
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        self.urlSession = NSURLSession(configuration: configuration)
        
        
        let request = NSURLRequest(URL: imageURL)
        
        let task = self.urlSession.dataTaskWithRequest(request) { (data, response, error) -> Void in
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                if error == nil && data != nil {
                    let image = UIImage(data: data!)
                    self.detailImageView.image = image
                }
            })
            
        }
        
        task.resume()
        
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.urlSession.invalidateAndCancel()
        self.urlSession = nil
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return detailImageView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        likeIcon = UIImage(named: "like")
        dislikeIcon = UIImage(named: "dislike")
        
        if choosenPhotoID == "" {
            
            if !alreadyLiked(photo.id) {
                let rightBarButton = UIBarButtonItem(image: dislikeIcon, style: .Done, target: self, action: #selector(likePhoto))
                self.navigationItem.rightBarButtonItem = rightBarButton
            }else {
                let rightBarButton = UIBarButtonItem(image: likeIcon, style: .Done, target: self, action: #selector(likePhoto))
                self.navigationItem.rightBarButtonItem = rightBarButton
            }
        } else {
            let rightBarButton = UIBarButtonItem(image: likeIcon, style: .Done, target: self, action: #selector(likePhoto))
            self.navigationItem.rightBarButtonItem = rightBarButton
        }
        
        
        
        
        let tapGesture  = UITapGestureRecognizer(target: self, action: #selector(likePhoto))
        tapGesture.numberOfTapsRequired = 2
        view.addGestureRecognizer(tapGesture)
        
        
    }
    
    func likePhoto() {
        
        
        if choosenPhotoID == "" {
            
            
            if !alreadyLiked(photo.id) {
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                let managedContext = appDelegate.managedObjectContext
                let entity = NSEntityDescription.entityForName("Liked", inManagedObjectContext: managedContext)
                let item = Liked(entity: entity!, insertIntoManagedObjectContext: managedContext)
                let regularString = String(photo.imageRegularURL)
                let smallString = String(photo.imageSmallURL)
                item.id = photo.id
                item.regularURL = regularString
                item.smallURL = smallString
                item.username = photo.name
                
                
                do {
                    try managedContext.save()
                    addedToLikeList()
                } catch  let error as NSError {
                    print(error.localizedDescription)
                }
            }
            
        } else {
            
            
            let alert = UIAlertController(title: "Delete Photo", message: "Do you want to remove the photo from your like list", preferredStyle: .Alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            let okAction = UIAlertAction(title: "OK", style: .Default) { (result: UIAlertAction) -> Void in
                self.dislikePhoto()
                self.navigationController?.popViewControllerAnimated(true)
                
            }
            
            alert.addAction(cancelAction)
            alert.addAction(okAction)
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
    }
    
    
    func dislikePhoto() {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let request = NSFetchRequest(entityName: "Liked")
        request.predicate = NSPredicate(format: "id = %@", self.choosenPhotoID)
        do {
            
            let results = try managedContext.executeFetchRequest(request)
            if results.count > 0 {
                for result in results {
                    managedContext.deleteObject(result as! NSManagedObject)
                    
                }
            }
            
            try managedContext.save()
            
            
        } catch let error  {
            print(error)
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName("deletedPhoto", object: nil)
    }
    
    func alreadyLiked(id: String) -> Bool{
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let request = NSFetchRequest(entityName: "Liked")
        request.predicate = NSPredicate(format: "id = %@", id)
        do {
            let results = try managedContext.executeFetchRequest(request)
            if results.count == 0 {
                return false
            }
        }catch  {
            print( "Error")
        }
        return true
    }
    
    func addedToLikeList() {
        
        let alert = UIAlertController(title: "Photo Like", message: "You have added the photo your like list", preferredStyle: .Alert)
        
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
       
        
        alert.addAction(okAction)
        self.presentViewController(alert, animated: true, completion: nil)
        
        let rightBarButton = UIBarButtonItem(image: likeIcon, style: .Done, target: self, action: #selector(likePhoto))
        self.navigationItem.rightBarButtonItem = rightBarButton
        
    }
    
}

