//: Playground - noun: a place where people can play

import UIKit

let image = UIImage(named: "sample")!

// My Code
public struct RGBAPixel {
    public init (rawVal: UInt32) {
        raw = rawVal
    }
    
    public var raw: UInt32
    
    public var red: UInt8 {
        get { return UInt8 (raw & 0xFF) }
        set { raw = UInt32(newValue) | (raw & 0xFFFFFF00) }
    }
    public var green: UInt8 {
        get { return UInt8 ((raw & 0xFF00) >> 8) }
        set { raw = (UInt32 (newValue) << 8) | (raw & 0xFFFF00FF) }
    }
    public var blue: UInt8 {
        get { return UInt8 ((raw & 0xFF0000) >> 16) }
        set { raw = (UInt32 (newValue) << 16) | (raw & 0xFF00FFFF) }
    }
    public var alpha: UInt8 {
        get { return UInt8 ((raw & 0xFF000000) >> 24) }
        set { raw = (UInt32 (newValue) << 24) | (raw & 0x00FFFFFF) }
    }
}

let pixels:UnsafeMutableBufferPointer<RGBAPixel>
public let height: Int;
public let width: Int;
let colorSpace = CGColorSpaceCreateDeviceRGB()
let bitmapInfo: UInt32 = CGBitmapInfo.ByteOrder32Big.rawValue | CGImageAlphaInfo.PremultipliedLast.rawValue
let bitPerComponent = 8
let bytesPerRow: Int;
    
height = Int(image.size.height)
width = Int(image.size.width)

// convert UIImage to RGBAImage
bytesPerRow = 4 * width
let rawData = UnsafeMutablePointer<RGBAPixel>.alloc(width * height)
let imageContext = CGBitmapContextCreate(rawData, width, height, bitPerComponent, bytesPerRow, colorSpace, bitmapInfo)
CGContextDrawImage(imageContext, CGRect(origin: CGPointZero, size: image.size), image.CGImage)
        
pixels = UnsafeMutableBufferPointer<RGBAPixel>(start: rawData, count: width * height)

    

/***
 ** Contrast Filter
 */
for y in 0..<height {
    for x in 0..<width {
        var p = pixels[x + y * width]
        //p.blue = 255
        let brightnessFactor = 100  // you can play with this value
        let newRed = Int(brightnessFactor + Int(p.red))
        let newGreen = Int(brightnessFactor + Int(p.green))
        let newBlue = Int(brightnessFactor + Int(p.blue))
        
        p.red = UInt8(min(max(newRed,0),255))
        p.green = UInt8(min(max(newGreen,0),255))
        p.blue = UInt8(min(max(newBlue,0),255))
        
        pixels[x + y * width] = p
        
    }
}

// convert it back to UIImage
let outContext = CGBitmapContextCreateWithData(pixels.baseAddress, width, height, bitPerComponent, bytesPerRow, colorSpace, bitmapInfo, nil, nil)
let outImage = UIImage(CGImage: CGBitmapContextCreateImage(outContext)!)


/***
 ** Brightness Filter
 */
for y in 0..<height {
    for x in 0..<width {
        let index = y * width + x
        
        var pixel = pixels[index]
        
        let brightnessFactor = 17   // you can play with this value
        
        let newRed = Int(brightnessFactor + Int(pixel.red))
        let newGreen = Int(brightnessFactor + Int(pixel.green))
        let newBlue = Int(brightnessFactor + Int(pixel.blue))
        
        pixel.red = UInt8(min(max(newRed,0),255))
        pixel.green = UInt8(min(max(newGreen,0),255))
        pixel.blue = UInt8(min(max(newBlue,0),255))
        
        pixels[index] = pixel
    }
}

// convert it back to UIImage
let outContext1 = CGBitmapContextCreateWithData(pixels.baseAddress, width, height, bitPerComponent, bytesPerRow, colorSpace, bitmapInfo, nil, nil)
let outImage1 = UIImage(CGImage: CGBitmapContextCreateImage(outContext1)!)

/***
 ** Gray Scale Filter
 */
for y in 0..<height {
    for x in 0..<width {
        let index = y * width + x
        
        var pixel = pixels[index]
        
        let intensity = 3   // you can play with this value
        
        var grayValue = Int((Int(pixel.red) + Int(pixel.green) + Int(pixel.blue)) / 3)
        grayValue = Int((intensity * (grayValue - 128)) + 128)
        
        pixel.red = UInt8(min(max(grayValue,0),255))
        pixel.green = UInt8(min(max(grayValue,0),255))
        pixel.blue = UInt8(min(max(grayValue,0),255))

        pixels[index] = pixel
    }
}

let outContext2 = CGBitmapContextCreateWithData(pixels.baseAddress, width, height, bitPerComponent, bytesPerRow, colorSpace, bitmapInfo, nil, nil)
let outImage2 = UIImage(CGImage: CGBitmapContextCreateImage(outContext2)!)


/***
 ** Sepia Filter
 */
for y in 0..<height {
    for x in 0..<width {
        let index = y * width + x
        
        let intensity = 33
        
        var pixel = pixels[index]
        var newRed = Int((393 * Int(pixel.red) + 769 * Int(pixel.green) + 189 * Int(pixel.blue)) / 1000)
        newRed = Int((intensity * (newRed - 128)) + 128)
        
        var newGreen = Int((349 * Int(pixel.red) + 686 * Int(pixel.green) + 168 * Int(pixel.blue)) / 1000)
        newGreen = Int((intensity * (newGreen - 128)) + 128)
        
        var newBlue = Int((272 * Int(pixel.red) + 534 * Int(pixel.green) + 131 * Int(pixel.blue)) / 1000)
        newBlue = Int((intensity * (newBlue - 128)) + 128)
        
        pixel.red = UInt8(min(max(newRed,0),255))
        pixel.green = UInt8(min(max(newGreen,0),255))
        pixel.blue = UInt8(min(max(newBlue,0),255))

        pixels[index] = pixel
    }
}

let outContext3 = CGBitmapContextCreateWithData(pixels.baseAddress, width, height, bitPerComponent, bytesPerRow, colorSpace, bitmapInfo, nil, nil)
let outImage3 = UIImage(CGImage: CGBitmapContextCreateImage(outContext3)!)  // lol the output :'D 
