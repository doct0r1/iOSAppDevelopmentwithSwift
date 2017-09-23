
import UIKit

/*    This Image Processor takes a full color image and converts the image to grayscale.  Any pixel that has equivalent Red, Green and Blue values will be some shade of gray. 0,0,0 is black and 255,255,255 is white.  The processor will iterate through each pixel and take the average of the three values and then set all three to the average value.
 
    ( R + G + B ) / 3
 
    Brightness of the image can have five values:
 
    "DIMMEST"
    "DIM"
    "BALANCED"
    "BRIGHT"
    "BRIGHTEST"
 
 Basic image setup statements and looping structure as well as indexing of pixels and pixel declaration statements were taken from course lecture examples.
 */

 let image = UIImage(named: "sample")!

// convert to RGBA image
 var myRGBA = RGBAImage(image: image)!
 //myRGBA.toUIImage()!
 
/*
  // Process the image!
 var grayscaleValue: Int = 0
 
 for y in 0..<myRGBA.height {
    for x in 0..<myRGBA.width {
        let index = y * myRGBA.width + x
        var pixel = myRGBA.pixels[index]
        grayscaleValue = (Int(pixel.red) + Int(pixel.green) + Int(pixel.blue))/3
        myRGBA.pixels[index].red = UInt8(grayscaleValue)
        myRGBA.pixels[index].green = UInt8(grayscaleValue)
        myRGBA.pixels[index].blue = UInt8(grayscaleValue)
        //pixel.red = UInt8(max(0,MIN(255,avgRed +reddiff*5))) )
 
    }
 
 }

//myRGBA.toUIImage()!
*/


class ImageProcessor {
 
    init(){
    }
 
    func Process(myImage: RGBAImage, processGrayScale: Bool, imageBrightness: String) -> RGBAImage {
        
        var myRGBA: RGBAImage
        var brightness: Int
        
        myRGBA = myImage
        
        // Set brightness of image
        brightness = setBrightness(imageBrightness)
        
        if processGrayScale {
 
            var grayscaleValue: Int = 0
            
            for y in 0..<myRGBA.height {
                for x in 0..<myRGBA.width {
                    let index = y * myRGBA.width + x
                    var pixel = myRGBA.pixels[index]
                    grayscaleValue = (Int(pixel.red) + Int(pixel.green) + Int(pixel.blue))/3
                    grayscaleValue += brightness
                    myRGBA.pixels[index].red = UInt8(max(0,min(255,grayscaleValue + brightness)))
                    myRGBA.pixels[index].green = UInt8(max(0,min(255,grayscaleValue + brightness)))
                    myRGBA.pixels[index].blue = UInt8(max(0,min(255,grayscaleValue + brightness)))
                }
                
            }
        }
        else{
            for y in 0..<myRGBA.height {
                for x in 0..<myRGBA.width {
                    let index = y * myRGBA.width + x
                    var pixel = myRGBA.pixels[index]
                    myRGBA.pixels[index].red = UInt8(max(0,min(255, Int(pixel.red) + brightness)))
                    myRGBA.pixels[index].green = UInt8(max(0,min(255, Int(pixel.green) + brightness)))
                    myRGBA.pixels[index].blue = UInt8(max(0,min(255, Int(pixel.blue) + brightness)))
                }
                
            }

        }
        
        return myRGBA
    }

 
    func setBrightness(b: String) -> Int {
        
        var brightness: Int
        
            switch b {
            case  "DIMMEST":
                brightness = -75
            case  "DIMMER":
                brightness = -50
            case  "DIM":
                brightness = -25
            case  "BALANCED":
                brightness = 0
            case  "BRIGHT":
                brightness = 50
            case  "BRIGHTER":
                brightness = 100
            case  "BRIGHTEST":
                brightness = 150
            default:
                brightness = 1
        }
        
        return brightness

    }

 }
 
 protocol ImageSettings {
 
    func setBrightness(b:String)
    var brightness: Int {get set}
 
 }

var newImage = ImageProcessor.self()

/*  To convert the image to grayscale, set processGrayScale to "true"
 
    To change brightness of image, change imageBrightness value.  Possible brightness values:
    "DIMMEST"
    "DIMMER"
    "DIM"
    "BALANCED"
    "BRIGHT"
    "BRIGHTER"
    "BRIGHTEST"
 */

//THESE TWO LINES DISPLAY THE IMAGE WITHOUT ANY FILTERING
myRGBA = newImage.Process(myRGBA, processGrayScale: false, imageBrightness: "BALANCED")
myRGBA.toUIImage()
//THESE TWO LINES DISPLAY THE IMAGE WITHOUT GRAYSCALE FILTERING BUT WITH BRIGHTNESS FILTERING
myRGBA = newImage.Process(myRGBA, processGrayScale: false, imageBrightness: "DIMMER")
myRGBA.toUIImage()

//myRGBA = newImage.Process(myRGBA, processGrayScale: true, imageBrightness: "BALANCED")
//myRGBA.toUIImage()

//myRGBA = newImage.Process(myRGBA, processGrayScale: true, imageBrightness: "BRIGHT")
//myRGBA.toUIImage()

