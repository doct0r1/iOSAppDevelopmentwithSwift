

import UIKit

//
// ImageProcessing.swift
//
public class ImageProcessor {
    // Manage and apply Filter instances to an image
    var image: UIImage
    //var _pipeline: [FilterBase]
    var my_pipeline: Array<AnyObject> = []
    var filter_map = [
        "B/W": FilterGrayscale(),
        "More Contrast": FilterIncreaseContrast(),
        "More Brightness": FilterBrightness(),
        "More Red": FilterRed(),
        "More Blue": FilterBlue(),
        "More Green": FilterGreen(),
        "Half Brightness": FilterBrightness(),
        "Black and White and Red All Over": FilterRedGrayscale(),
        ]
    
    
    public init(image_name: String, pipeline: Array<AnyObject>) {
        self.image = UIImage(named: image_name)!
        self.my_pipeline = pipeline
    }
    
    public init(image: UIImage, pipeline: Array<AnyObject>) {
        self.image = UIImage(CGImage: CGImageCreateCopy(image.CGImage)!)
        self.my_pipeline = pipeline
    }
    
    public func filter(intensity: Double = 1.5) -> UIImage {
        let rgbaImage = run(intensity)
        return rgbaImage.toUIImage()!
    }
    
    public func filter(image: UIImage, intensity: Double = 1.5) -> UIImage {
        self.image = UIImage(CGImage: CGImageCreateCopy(image.CGImage)!)
        let rgbaImage = run(intensity)
        return rgbaImage.toUIImage()!
    }
    
    public func run(intensity: Double = 10.0) -> RGBAImage! {
        var rgbaImage = RGBAImage(image: self.image)!
        var f: FilterBase = FilterBase()
        
        for filter in my_pipeline {
            if (filter is String) {
                if let obj = filter_map[filter as! NSCopying as! String] {
                    f = obj as FilterBase
                } else {
                    // invalid filter
                }
            } else {
                f = filter as! FilterBase
            }
            print("\(f.filtername)" + String(intensity))
            rgbaImage = f.run(rgbaImage, intensity: intensity)
        }
        
        return rgbaImage
    }
    
    public func intense(intense: UInt8) {
        
    }
}


















