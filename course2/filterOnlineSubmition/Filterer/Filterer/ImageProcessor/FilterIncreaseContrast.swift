

import UIKit

//
// FilterIncreaseContrast.swift
//
public class FilterIncreaseContrast: FilterBase {
    // Make darks really dark, make lights slightly lighter
    override public var filtername:String {
        return "Increase Contrast By 10 Filter"
    }
    
    override public func run(rgbaImage: RGBAImage, intensity: Double = 1.5) -> RGBAImage {
        let averages = calculate_averages(rgbaImage)
        var rgbaImage2 = rgbaImage
        
        // apply a filter to each pixel of the image
        for y in 0..<rgbaImage.height {
            for x in 0..<rgbaImage.width {
                let index = y * rgbaImage.width + x
                var pixel = rgbaImage2.pixels[index]
                
                let redDelta = Int(pixel.red) - averages.avgRed
                let greenDelta = Int(pixel.green) - averages.avgGreen
                let blueDelta = Int(pixel.blue) - averages.avgBlue
                
                let redVal: Double = Double(averages.avgRed) + intensity * Double(redDelta)
                let greenVal: Double = Double(averages.avgGreen) + intensity + Double(greenDelta)
                let blueVal: Double = Double(averages.avgBlue) + intensity + Double(blueDelta)
                pixel.red = UInt8(max(min(255, redVal), 0))
                pixel.green = UInt8(max(min(255, greenVal), 0))
                pixel.blue = UInt8(max(min(255, blueVal), 0))
                
                rgbaImage2.pixels[index] = pixel
            }
        }
        return rgbaImage2
    }
}
