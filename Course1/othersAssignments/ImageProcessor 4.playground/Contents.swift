//: Playground - noun: a place where people can play

//image processor that ampliflies all of the red, green, and blue pixels in an image. amplification can be adjusted.
// By Eric Zhong

import UIKit

let image = UIImage(named: "sample.png")!
var filteredImage = UIImage()

var myRGBA = RGBAImage(image: image)!

var totalRed = 0
var totalBlue = 0
var totalGreen = 0
//function for red pixel enhancement
func redEnhance(Intensity: Int){
    for y in 0..<myRGBA.height {
    for x in 0..<myRGBA.width{
        let index = y * myRGBA.width + x
        var pixel = myRGBA.pixels[index]
        totalRed += Int(pixel.red)
        totalGreen += Int(pixel.green)
        totalBlue += Int(pixel.blue)
    }
}

let count = myRGBA.height * myRGBA.width
let avgRed = totalRed/count
//let avgGreen = totalGreen/count
//let avgBlue = totalBlue/count

for y in 0..<myRGBA.height{
    for x in 0..<myRGBA.width{
        let index = y * myRGBA.width + x
        var pixel = myRGBA.pixels[index]
        let redDiff = Int(pixel.red) - avgRed
        if (redDiff>0)
        {
            pixel.red = UInt8( max(0,min(255,avgRed+redDiff*Intensity) ) )
            myRGBA.pixels[index] = pixel
        }
        
    }
}
}

func blueEnhance(Intensity: Int) {
    for y in 0..<myRGBA.height {
        for x in 0..<myRGBA.width{
            let index = y * myRGBA.width + x
            var pixel = myRGBA.pixels[index]
            totalRed += Int(pixel.red)
            totalGreen += Int(pixel.green)
            totalBlue += Int(pixel.blue)
        }
    }
    
    let count = myRGBA.height * myRGBA.width
    //let avgRed = totalRed/count
    //let avgGreen = totalGreen/count
    let avgBlue = totalBlue/count
    
    for y in 0..<myRGBA.height{
        for x in 0..<myRGBA.width{
            let index = y * myRGBA.width + x
            var pixel = myRGBA.pixels[index]
            let blueDiff = Int(pixel.blue) - avgBlue
            if (blueDiff>0)
            {
                pixel.blue = UInt8( max(0,min(255,avgBlue+blueDiff*Intensity) ) )
                myRGBA.pixels[index] = pixel
            }
            
        }
    }

}

func greenEnhance(Intensity: Int) {
    for y in 0..<myRGBA.height {
        for x in 0..<myRGBA.width{
            let index = y * myRGBA.width + x
            var pixel = myRGBA.pixels[index]
            totalRed += Int(pixel.red)
            totalGreen += Int(pixel.green)
            totalBlue += Int(pixel.blue)
        }
    }
    
    let count = myRGBA.height * myRGBA.width
    //let avgRed = totalRed/count
    let avgGreen = totalGreen/count
    //let avgBlue = totalBlue/count
    
    for y in 0..<myRGBA.height{
        for x in 0..<myRGBA.width{
            let index = y * myRGBA.width + x
            var pixel = myRGBA.pixels[index]
            let greenDiff = Int(pixel.green) - avgGreen
            if (greenDiff>0)
            {
                pixel.green = UInt8( max(0,min(255,avgGreen+greenDiff*Intensity) ) )
                myRGBA.pixels[index] = pixel
            }
            
        }
    }

}

//not really grayscale, but kind of cool nonetheless
func GrayScale (){
    for y in 0..<myRGBA.height {
        for x in 0..<myRGBA.width{
            let index = y * myRGBA.width + x
            var pixel = myRGBA.pixels[index]
            totalRed += Int(pixel.red)
            totalGreen += Int(pixel.green)
            totalBlue += Int(pixel.blue)
        }
    }
    
    let count = myRGBA.height * myRGBA.width
    //let avgRed = totalRed/count
    let avgGreen = totalGreen/count
    //let avgBlue = totalBlue/count
    
    for y in 0..<myRGBA.height{
        for x in 0..<myRGBA.width{
            let index = y * myRGBA.width + x
            var pixel = myRGBA.pixels[index]
            let greenDiff = Int(pixel.green) - avgGreen
            if (greenDiff>0)
            {
                pixel.green = 78
                pixel.blue = 78
                pixel.red = 78
                myRGBA.pixels[index] = pixel
            }
            
        }
    }

}

let fileURL = NSBundle.mainBundle().URLForResource("sample", withExtension: "png")
CIImage(contentsOfURL: fileURL!)

func brightness() {
    struct Color {
        let filter : CIFilter
        init(inputImage: CIImage, inputSaturation: CGFloat = 1.0, inputBrightness: CGFloat = 5.0, inputContrast: CGFloat = 1.0) {
            let parameters:[String : AnyObject] = [
                "inputImage":inputImage,
                "inputSaturation":inputSaturation,
                "inputBrightness":inputBrightness,
                "inputContrast":inputContrast		]
            guard let filter = CIFilter(name:"CIColorControls", withInputParameters: parameters) else { fatalError() }
            self.filter = filter
            print("hoo rah")
            filteredImage = UIImage(CIImage: filter.outputImage!)
            
        }
        
    }
    print("struct did not run :(")
    UIImageView(image:filteredImage)

}

let newfilteredImage = UIImageView(image: filteredImage)

struct pixelFilter{
    var type: String
    var Intensity: Int
    
}

//adjust type value for type of filter; lower intesity = less effect, higher intensity = more effect
var typeOfFilter = pixelFilter(type: "gray", Intensity: 7)

print(typeOfFilter.type)

switch typeOfFilter.type {
case "red" :
    redEnhance(typeOfFilter.Intensity)
    print("preforming red pixel enhancement")
case "blue" :
    blueEnhance(typeOfFilter.Intensity)
    print("preforming blue pixel enhancement")
case "green" :
    greenEnhance(typeOfFilter.Intensity)
    print ("preforming green pixel enhancement")
case "gray" :
    GrayScale()
    print("applying gray *ish* filter")
case "brightness 50%" :
    print("changing brightness")
    brightness()
default:
    print ("please input a valid enhancement")
}

let newImage2 = myRGBA.toUIImage()

