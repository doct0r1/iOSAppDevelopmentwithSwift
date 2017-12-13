//
//  ViewController.swift
//  CoreImage1
//
//  Created by Mustafa Jamal on 11/9/17.
//  Copyright © 2017 Mustafa Jamal. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // some variables of type CGFloat
        var xCoord: CGFloat = 5
        let yCoord: CGFloat = 5
        let buttonWidth: CGFloat = 70
        let buttonHight: CGFloat = 63
        let gapBetweenButtons: CGFloat = 5
        
        // loop to duplicate a custom UIButton and place it in ScrollView based on above values
        var itemCount = 0
        
        for i in 0..<CIFilterNames.count {
            itemCount = i
            
            // Button properities
            let filterButton = UIButton(type: .Custom)
            filterButton.frame = CGRectMake(xCoord, yCoord, buttonWidth, buttonHight)
            filterButton.tag = itemCount
            filterButton.addTarget(self, action: #selector(self.filterButtonTapped(_:)), forControlEvents: .TouchUpInside)
            filterButton.layer.cornerRadius = 6
            filterButton.clipsToBounds = true
            
            // add the image to the buttons and apply filters
            let ciContext = CIContext(options: nil)
            let coreImage = CIImage(image: originalImage.image!)
            let filter = CIFilter(name: "\(CIFilterNames[i])" )     // <- L satr da fashi5
            filter!.setDefaults()
            filter!.setValue(coreImage, forKey: kCIInputImageKey)
            let filteredImageData = filter!.valueForKey(kCIOutputImageKey) as! CIImage
            let filteredImageRef = ciContext.createCGImage(filteredImageData, fromRect: filteredImageData.extent)
            let imageForButton = UIImage(CGImage: filteredImageRef);
            // assign filtered image to the button
            filterButton.setBackgroundImage(imageForButton, forState: .Normal)
            
            // Add Buttons in the ScrollView
            xCoord += buttonWidth + gapBetweenButtons
            filterScrollView.addSubview(filterButton)
        }
        
        // Resize ScrollView
        filterScrollView.contentSize = CGSizeMake(buttonWidth, buttonHight)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet var containerView: UIView!
    
    @IBOutlet var originalImage: UIImageView!
    
    @IBOutlet var imageToFilter: UIImageView!
    
    @IBOutlet var filterScrollView: UIScrollView!
    
    @IBOutlet var saveButton: UIButton!
    
    class ViewController: UIViewController {
        
    }
    
    // create a global array of CIFilter names
    var CIFilterNames = ["CIPhotoEffectChrome",
                         "CIPhotoEffectFade",
                         "CIPhotoEffectInstant",
                         "CIPhotoEffectNoir",
                         "CIPhotoEffectProcess",
                         "CIPhotoEffectTonal",
                         "CIPhotoEffectTransfer",
                         "CISepiaTone"]
    
    // Filter Button Action
    func filterButtonTapped(sender: UIButton) {
        let button = sender as UIButton
        
        imageToFilter.image = button.backgroundImageForState(UIControlState.Normal)
    }
    
    // Save Image into camera roll
    @IBAction func savePicButton(sender: UIButton) {
        UIImageWriteToSavedPhotosAlbum(imageToFilter.image!, nil, nil, nil)
        
        let alert = UIAlertView(title: "Filters", message: "Your Image has been saved to photo library", delegate: nil, cancelButtonTitle: "OK")
        alert.show()
    }
}

