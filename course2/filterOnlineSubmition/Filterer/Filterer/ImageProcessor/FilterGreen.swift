

import UIKit

//
// FilterRed.swift
//
public class FilterGreen: FilterBase {
    // Make the image a bit more reddish
    override public var filtername:String {
        return "Increase Greeness Filter"
    }
    
    override public func run(image: RGBAImage, intensity: Double = 1.5) -> RGBAImage {
        let averages = calculate_averages(image)
        var rgbaImage = image
        
        // apply a filter to each pixel of the image
        for y in 0..<rgbaImage.height {
            for x in 0..<rgbaImage.width {
                let index = y * rgbaImage.width + x
                var pixel = rgbaImage.pixels[index]
                
                let greenDelta = Int(pixel.green) - averages.avgGreen
                // increase the greens, don't modify blues and reds
                if (Int(pixel.green) > averages.avgGreen) {
                    pixel.green = UInt8(max(min(255, (Double(averages.avgGreen) + intensity * Double(greenDelta))), 0))
                } else {
                    
                }
                rgbaImage.pixels[index] = pixel
            }
        }
        return rgbaImage
    }
}

