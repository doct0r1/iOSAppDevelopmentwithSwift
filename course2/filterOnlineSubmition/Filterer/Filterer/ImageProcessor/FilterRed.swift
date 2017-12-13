

import UIKit

//
// FilterRed.swift
//
public class FilterRed: FilterBase {
    // Make the image a bit more reddish
    override public var filtername:String {
        return "Increase Redness Filter"
    }
    
    override public func run(image: RGBAImage, intensity: Double = 1.5) -> RGBAImage {
        let averages = calculate_averages(image)
        var rgbaImage = image
        
        // apply a filter to each pixel of the image
        for y in 0..<rgbaImage.height {
            for x in 0..<rgbaImage.width {
                let index = y * rgbaImage.width + x
                var pixel = rgbaImage.pixels[index]
                
                let redDelta = Int(pixel.red) - averages.avgRed
                // increase the reds, don't modify blues and greens
                if (Int(pixel.red) > averages.avgRed) {
                    pixel.red = UInt8(max(min(255, (Double(averages.avgRed) + intensity * Double(redDelta))), 0))
                } else {
                    
                }
                rgbaImage.pixels[index] = pixel
            }
        }
        return rgbaImage
    }
}

