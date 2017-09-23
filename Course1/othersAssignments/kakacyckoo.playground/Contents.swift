//: Playground - noun: a place where people can play

import Foundation
import UIKit

// add computed properties for Pixel struct

extension Pixel{
    
    public var brightness: UInt8{
        get {
            
            let average = ((Int(red) + Int(green) + Int(blue))/3)
            
            if average >= 255{
                return (255)
            } else {
                return UInt8(average)
            }
        }
        set {
            
            let oldValue = ((Int(red) + Int(green) + Int(blue))/3)
            let diffValue = Int(newValue) - oldValue
            
            // RED block
            if (diffValue + Int(red)) > 255 {
                red = 255
            } else if (diffValue + Int(red)) < 0{
                red = 0
            }else {
                red = UInt8(Int(red) + diffValue)
            }
            
            // GREEN block
            if (diffValue + Int(green)) > 255 {
                green = 255
            } else if (diffValue + Int(green)) < 0{
                green = 0
            }else {
                green = UInt8(Int(green) + diffValue)
            }
            
            // BLUE block
            if (diffValue + Int(blue)) > 255 {
                blue = 255
            } else if (diffValue + Int(blue)) < 0{
                blue = 0
            }else {
                blue = UInt8(Int(blue) + diffValue)
            }
            
        }
    }
}

//here we define presets name for filter

enum Presets {
    
    case neutral
    case strong
    case medium
    case horror
    case lower
}


public class ImageProcessor {
    
    let image: UIImage
    
    var RGBAPicture: RGBAImage
    
    var newImage: UIImage?
    
    //this constant define the filter power
    
    var power: Double
    
    init(fromPicture picName:String, preset:Presets){
        
        image = UIImage.init(imageLiteral: picName)
        
        switch preset{
        case .neutral: power = 1.0
        case .strong: power = 2.0
        case .medium: power = 0.5
        case .horror: power = -2.0
        case .lower: power = -0.3
        }
        
        //let's make new RGBA picture
        
        RGBAPicture = RGBAImage.init(image: image)!
        
        performFilter()
    }
    
    init(fromPicture picName:String, filterPower pwr:Double){
        
        image = UIImage.init(imageLiteral: picName)
        
        RGBAPicture = RGBAImage.init(image: image)!
        
        power = pwr
        
        performFilter()
    }
    
    public func performFilter(){
        
        // let's encout all pixels from image and do the contrast math
        
        for y in 0..<RGBAPicture.height {
            for x in 0..<RGBAPicture.width {
                
                var pixel = RGBAPicture.pixels[ImageProcessor.getIndex(x, y: y, imageW: RGBAPicture.width)]
                
                let newBrightness = ImageProcessor.contrast(power, brightness: pixel.brightness)
                
                pixel.brightness = newBrightness
                
                RGBAPicture.pixels[ImageProcessor.getIndex(x, y: y, imageW: RGBAPicture.width)] = pixel
            }
        }
        
        newImage = RGBAPicture.toUIImage()
        
    }
    
    //this function calculates new contrasted brightness for pixel
    static func contrast (coeff:Double, brightness:UInt8) ->UInt8{
        
        //output brightness depens on the old brightness value as a sin function
        // f = x - coef * sin(x/40.60)
        let contrastFunction: Double = Double(brightness) - Double(brightness) * coeff * sin(Double(brightness)/40.60) //calculatind dF
        switch contrastFunction {
        case let a where a > 255 : return 255
        case let b where b < 0 : return 0
            
        default : return UInt8(contrastFunction)
        }
        
    }
    
    //that method calculates index for RGBAImage's pixels array
    
    static func getIndex(x:Int, y:Int, imageW:Int) ->Int{
        return y * imageW + x
    }
    
}

//let's test our cool filter

let firstTry = ImageProcessor.init(fromPicture: "sinth.jpg", filterPower: 1.3)

firstTry.newImage
firstTry.image

let secondTry = ImageProcessor.init(fromPicture: "mountain3.jpeg", filterPower: 1.7)

secondTry.newImage

//let's test our presets

let preset1 = ImageProcessor.init(fromPicture: "sinth.jpg", preset: Presets.neutral)

preset1.newImage

let preset2 = ImageProcessor.init(fromPicture: "sinth.jpg", preset: Presets.lower)

preset2.newImage

let preset3 = ImageProcessor.init(fromPicture: "sinth.jpg", preset: Presets.medium)

preset3.newImage

let preset4 = ImageProcessor.init(fromPicture: "sinth.jpg", preset: Presets.strong)

preset4.newImage

let preset5 = ImageProcessor.init(fromPicture: "sinth.jpg", preset: Presets.horror)

preset5.newImage


