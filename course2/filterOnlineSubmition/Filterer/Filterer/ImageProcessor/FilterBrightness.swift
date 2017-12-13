

import UIKit

//
// FilterBrightness.swift
//
public class FilterBrightness: FilterBase {
    
    override public var filtername: String {
        return "Brightness Filter"
    }
    
    override public func run(image: RGBAImage, intensity: Double = 0.5) -> RGBAImage {
        // apply a filter to each pixel of the image
        var rgbaImage = image
        
        for y in 0..<rgbaImage.height {
            for x in 0..<rgbaImage.width {
                let index = y * rgbaImage.width + x
                var pixel = rgbaImage.pixels[index]
                
                let red = intensity * Double(pixel.red)
                let green = intensity * Double(pixel.green)
                let blue = intensity * Double(pixel.blue)
                
                pixel.red = UInt8(max(min(red, 255), 0))
                pixel.green = UInt8(max(min(green, 255), 0))
                pixel.blue = UInt8(max(min(blue, 255), 0))
                rgbaImage.pixels[index] = pixel
            }
        }
        return rgbaImage
    }
}
