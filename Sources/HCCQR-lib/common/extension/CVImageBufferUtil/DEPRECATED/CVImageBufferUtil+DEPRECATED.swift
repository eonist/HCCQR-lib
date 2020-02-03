import Foundation

//public static func imageBuffer(image: Image) throws -> CVImageBuffer {
//   let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
//   var imageBuffer: CVImageBuffer?
//   // caution: ⚠️️ the kCVPixelFormatType_32ARGB can cause issues when trying to read individual pixels later
//   //      public var kCVPixelFormatType_32ARGB: OSType { get } /* 32 bit ARGB */
//   //      public var kCVPixelFormatType_32BGRA: OSType { get } /* 32 bit BGRA */
//   //      public var kCVPixelFormatType_32ABGR: OSType { get } /* 32 bit ABGR */
//   //      public var kCVPixelFormatType_32RGBA:
//   let type: OSType = kCVPixelFormatType_32BGRA//kCVPixelFormatType_DepthFloat32//kCVPixelFormatType_32RGBA////kCVPixelFormatType_32RGBA//kCVPixelFormatType_DepthFloat32//kCVPixelFormatType_32RGBA//kCVPixelFormatType_DepthFloat32 // kCVPixelFormatType_32ARGB
//   let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(image.size.width), Int(image.size.height), type, attrs, &imageBuffer)
//   guard status == kCVReturnSuccess else { throw NSError(domain: "", code: 0) }
//   CVPixelBufferLockBaseAddress(imageBuffer!, CVPixelBufferLockFlags(rawValue: 0))
//   let pixelData = CVPixelBufferGetBaseAddress(imageBuffer!)
//   // Convert the base address to a safe pointer of the appropriate type
//
//   let rgbColorSpace = image.cgImage!.colorSpace!//CGColorSpaceCreateDeviceRGB()
//   Swift.print("rgbColorSpace:  \(rgbColorSpace)")
//   let size: (width: Int, height: Int) = (Int(image.size.width *  image.scale), Int(image.size.height * image.scale))
//   Swift.print("CVPixelBufferGetBytesPerRow(imageBuffer!):  \(CVPixelBufferGetBytesPerRow(imageBuffer!))")
//   //      guard let imgBuffer = imageBuffer, let bytesPerRow = Optional(CVPixelBufferGetBytesPerRow(imgBuffer))/*image.cgImage?.bitsPerPixel*/ else { Swift.print("err getting bytesPerRow"); throw NSError(domain: "err", code: 0) }//
//   guard let bytesPerRow = image.cgImage?.bitsPerPixel else { throw NSError(domain: "err", code: 0) }//
//   Swift.print("image.cgImage!.bitmapInfo.rawValue:  \(image.cgImage!.bitmapInfo.rawValue)")
//   Swift.print("RGBImage.bitmapInfo:  \(RGBImage.bitmapInfo)")
//   let bitmapInfo: UInt32 = image.cgImage!.bitmapInfo.rawValue//RGBImage.bitmapInfo//CGBitmapInfo.byteOrder32Big.rawValue// CGImageAlphaInfo.noneSkipFirst.rawValue
//   //      let bitsPerPixel = image.cgImage!.bitsPerPixel
//   let bitsPerComponent = 8
//   guard let context = CGContext(data: pixelData, width: size.width, height: size.height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: rgbColorSpace, bitmapInfo: bitmapInfo) else { Swift.print("Unable to get context"); throw NSError(domain: "Unable to get context", code: 0) }
//   drawContext(context: context, image: image)
//
//
//   CVPixelBufferUnlockBaseAddress(imageBuffer!, CVPixelBufferLockFlags(rawValue: 0))
//   return imageBuffer!
//}
