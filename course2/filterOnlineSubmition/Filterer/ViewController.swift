//
//  ViewController.swift
//  Filterer
//
//  Created by Arkadiusz Cieśliński on 07/10/2017.
//  Copyright © 2017 Arkadiusz Cieśliński. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var filterView: UIImageView!
    
    @IBOutlet var secondaryMenu: UIView!
    
    @IBOutlet var sliderMenu: UIView!
    
    @IBOutlet weak var bottomMenu: UIView!
    
    @IBOutlet weak var filterButton: UIButton!
    
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var slider: UISlider!
    
    @IBOutlet weak var compareButton: UIButton!
    @IBOutlet weak var overly: UIView!
    @IBOutlet weak var overlyLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let filterImages = [
        ImageProcessor(
            image: UIImage(named: "sample.jpg")!,
            pipeline: [
                "More Red",
            ]).filter(),
        ImageProcessor(
            image: UIImage(named: "sample.jpg")!,
            pipeline: [
                "More Green",
            ]).filter(),
        ImageProcessor(
            image: UIImage(named: "sample.jpg")!,
            pipeline: [
                "More Blue",
            ]).filter(),
        ImageProcessor(
            image: UIImage(named: "sample.jpg")!,
            pipeline: [
                "More Red",
                "More Green",
            ]).filter(),
        ImageProcessor(
            image: UIImage(named: "sample.jpg")!,
            pipeline: [
                "More Red",
                "More Blue",
            ]).filter(),
        ImageProcessor(
            image: UIImage(named: "sample.jpg")!,
            pipeline: [
                "More Brightness",
            ]).filter(),
        ImageProcessor(
            image: UIImage(named: "sample.jpg")!,
            pipeline: [
                "More Contrast",
            ]).filter(),
        ]
    
    
    var imageProcessor: ImageProcessor?
    
    override func viewDidLoad() {
        (self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout).minimumLineSpacing = 1000.0;
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        print("\(indexPath.section)")
        print("\(indexPath.row)")
        
        switch indexPath.section {
        case 0:
            imageProcessor = ImageProcessor(
                image: imageView.image!,
                pipeline: [
                    "More Red",
                ])
            
            filter()
            break
        case 1:
            imageProcessor = ImageProcessor(
                image: imageView.image!,
                pipeline: [
                    "More Green",
                ])
            
            filter()
            break
        case 2:
            imageProcessor = ImageProcessor(
                image: imageView.image!,
                pipeline: [
                    "More Blue",
                ])
            
            filter()
            break
        case 3:
            imageProcessor = ImageProcessor(
                image: imageView.image!,
                pipeline: [
                    "More Red",
                    "More Green",
                ])
            
            filter()
            break
        case 4:
            imageProcessor = ImageProcessor(
                image: imageView.image!,
                pipeline: [
                    "More Red",
                    "More Blue",
                ])
            
            filter()
            break
        case 5:
            imageProcessor = ImageProcessor(
                image: imageView.image!,
                pipeline: [
                    "More Brightness",
                ])
            
            filter()
            break
        default:
            imageProcessor = ImageProcessor(
                image: imageView.image!,
                pipeline: [
                    "More Contrast",
                ])
            
            filter()
            break
        }
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 7
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionViewCell", forIndexPath: indexPath) as! CollectionViewCell
//        cell.button.addTarget(self, action: Selector("action:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        cell.button.setBackgroundImage(filterImages[indexPath.section], forState: .Normal)
        
        return cell
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch : UITouch! = touches.first!
        
        if (imageView == touch.view && filterView.image != nil) {
            showFilterView()
        }
        
        if (filterView == touch.view) {
            hideFilterView()
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch : UITouch! = touches.first!
        
        if (filterView.image != nil) {
            if (imageView == touch.view) {
                hideFilterView()
            }
            
            if (filterView == touch.view) {
                showFilterView()
            }
        }
    }
    
    @IBAction func onNewPhoto(sender: UIButton) {
        let actionSheet = UIAlertController(title: "New Photo", message: nil, preferredStyle: .ActionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .Default, handler: { (action) in
            self.showCamera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Album", style: .Default, handler: { (action) in
            self.showAlbum()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    func showCamera() {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .Camera
        
        presentViewController(cameraPicker, animated: true, completion: nil)
        
    }
    
    func showAlbum() {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .PhotoLibrary
        
        presentViewController(cameraPicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        dismissViewControllerAnimated(true, completion: nil)
        
        if let imageInfo = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = imageInfo
            compareButton.enabled = false
            compareButton.selected = false
            editButton.enabled = false
            editButton.selected = false
            
            self.hideSliderMenu()
            self.hideFilterView()
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onSlide(sender: UISlider) {
        slider.enabled = false
        filterView.image = imageProcessor?.filter(imageView.image!, intensity: Double(sender.value)) ?? nil
        slider.enabled = true
    }
    
    @IBAction func onCompare(sender: UIButton) {
        if (sender.selected) {
            hideFilterView()
            sender.selected = false
        } else {
            showFilterView()
            sender.selected = true
        }
    }
    
    @IBAction func onEdit(sender: UIButton) {
        if (sender.selected) {
            hideSliderMenu()
            sender.selected = false
        } else {
            showSliderMenu()
            sender.selected = true
            filterButton.selected = false
        }
        
        secondaryMenu.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
    }
    
    @IBAction func onFilter(sender: UIButton) {
        if (sender.selected) {
            hideSecondaryMenu()
            sender.selected = false
        } else {
            showSecondaryMenu()
            sender.selected = true
            editButton.selected = false
        }
        
        secondaryMenu.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
    }
    
    
    @IBAction func onShare(sender: UIButton) {
        let activityController = UIActivityViewController(activityItems: [imageView.image!], applicationActivities: nil)
        
        presentViewController(activityController, animated: true, completion: nil)
        
    }
    
    func filter() {
        filterView.image = imageProcessor?.filter(3.0)
        slider.value = 3.0
        
        showFilterView()
    }
    
    func showFilterView() {
        UIView.animateWithDuration(0.4, animations: {
            self.filterView.alpha = 1.0
            self.imageView.alpha = 0.0
            self.overly.alpha = 0.0
            self.overlyLabel.alpha = 0.0
        }) { completed in
            if (completed) {
                self.compareButton.selected = true
                self.compareButton.enabled = true
                self.editButton.enabled = true
            }
        }
    }
    
    func hideFilterView() {
        UIView.animateWithDuration(1) {
            self.filterView.alpha = 0.0
            self.imageView.alpha = 1.0
            self.compareButton.selected = false
            self.overly.alpha = 0.5
            self.overlyLabel.alpha = 1.0
        }
    }
    
    func showSecondaryMenu() {
        view.addSubview(secondaryMenu)
        
        secondaryMenu.translatesAutoresizingMaskIntoConstraints = false
        
        let bottomConstraint = secondaryMenu.bottomAnchor.constraintEqualToAnchor(bottomMenu.topAnchor)
        let leftConstraint = secondaryMenu.leftAnchor.constraintEqualToAnchor(view.leftAnchor)
        let rightConstraint = secondaryMenu.rightAnchor.constraintEqualToAnchor(view.rightAnchor)
        
        let heightConstraint = secondaryMenu.heightAnchor.constraintEqualToConstant(40)
        
        NSLayoutConstraint.activateConstraints([bottomConstraint, leftConstraint, rightConstraint, heightConstraint])
        
        view.layoutIfNeeded()
        
        UIView.animateWithDuration(1) {
            self.secondaryMenu.alpha = 1.0
        }
        
        hideSliderMenu()
    }
    
    func hideSecondaryMenu() {
        secondaryMenu.removeFromSuperview()
        
        UIView.animateWithDuration(0.4, animations: {
            self.secondaryMenu.alpha = 0
        }) { completed in
            if (completed) {
                self.secondaryMenu.removeFromSuperview()
            }
        }
    }
    
    func showSliderMenu() {
        view.addSubview(sliderMenu)
        
        sliderMenu.translatesAutoresizingMaskIntoConstraints = false
        
        let bottomConstraint = sliderMenu.bottomAnchor.constraintEqualToAnchor(bottomMenu.topAnchor)
        let leftConstraint = sliderMenu.leftAnchor.constraintEqualToAnchor(view.leftAnchor)
        let rightConstraint = sliderMenu.rightAnchor.constraintEqualToAnchor(view.rightAnchor)
        
        let heightConstraint = sliderMenu.heightAnchor.constraintEqualToConstant(20)
        
        NSLayoutConstraint.activateConstraints([bottomConstraint, leftConstraint, rightConstraint, heightConstraint])
        
        view.layoutIfNeeded()
        
        UIView.animateWithDuration(1) {
            self.sliderMenu.alpha = 1.0
        }
        
        hideSecondaryMenu()
    }
    
    func hideSliderMenu() {
        sliderMenu.removeFromSuperview()
        
        UIView.animateWithDuration(0.4, animations: {
            self.sliderMenu.alpha = 0
        }) { completed in
            if (completed) {
                self.sliderMenu.removeFromSuperview()
            }
        }
    }
}

class CollectionViewCell : UICollectionViewCell {
    @IBOutlet weak var button : UIButton!
}

