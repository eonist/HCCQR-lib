import Foundation
import QuartzCore
import CoreImage

public final class RGBAImageUtil {
   /**
    * Converts rgbaImage to uiimage / nsimage
    * - Parameter scale: the amount to scale the image by (screenScale)
    * - Note: used by the colorize process
    */
   static func image(rgbaImage: RGBAImage, scale: CGFloat) throws -> Image {
      let cgImage: CGImage = try RGBAImageUtil.cgImage(rgbaImage: rgbaImage)
      return ImageUtil.image(cgImage: cgImage, scale: scale) // Convert CGImage to UIImage
   }
   /**
    * RGBAImage -> CIImage
    * - Note: The composite method uses this method
    */
   static func ciImage(rgbaImage: RGBAImage) throws -> CIImage {
      let cgImage: CGImage = try RGBAImageUtil.cgImage(rgbaImage: rgbaImage, useGrayscale: true)
//      return CIImage(cgImage: cgImage, options: [CIImageOption.colorSpace: CGColorSpaceCreateDeviceGray()])
      return cgImage.ciImage() // we convert to CIImage here, because apples QRReader reades CIImage
      // Fixme: ⚠️️ we can prob create ciImage directly for better speed, see RGBKit and related research
//      return ciImg(rgbaImage: rgbaImage)
   }
}
/**
 * Privsate static helper method
 */
extension RGBAImageUtil {
   /**
    * Converts rgbaImage to cgImage
    * - Note: alternative data -> img code, might be faster?: https://stackoverflow.com/questions/51372245/swift-covert-byte-array-into-ciimage
    */
   private static func cgImage(rgbaImage: RGBAImage, useGrayscale: Bool = false) throws -> CGImage {
//      Swift.print("useGrayscale:  \(useGrayscale)")
      let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceRGB()//useGrayscale ? CGColorSpaceCreateDeviceGray() : CGColorSpaceCreateDeviceRGB()
      // Fixme: ⚠️️ convert to grayscale instead, its prob faster
      var bitmapInfo: UInt32 = CGBitmapInfo.byteOrder32Big.rawValue
      let bytesPerRow: Int = rgbaImage.width * 4
      bitmapInfo |= CGImageAlphaInfo.premultipliedLast.rawValue & CGBitmapInfo.alphaInfoMask.rawValue
      guard let imageContext = CGContext(data: rgbaImage.pixels.baseAddress, width: rgbaImage.width, height: rgbaImage.height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo, releaseCallback: nil, releaseInfo: nil) else { throw NSError(domain: "Unable to create imageContext", code: 0) }
//      Swift.print("imageContext")
      guard let cgImage: CGImage = imageContext.makeImage() else { throw NSError(domain: "Unable to create cgImage", code: 0) }
//      cgImage.ciImage()
//      Swift.print("cgImage.width:  \(cgImage.width)")
      return /*useGrayscale ? convertToGrayScale(cgImage: cgImage) : */cgImage
   }

   /**
    * experimental (⚠️️ Not working ⚠️️)
    */
   private static func ciImg(rgbaImage: RGBAImage) -> CIImage {
      let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceRGB() // The color space that the image is defined in. It must be a Quartz 2D color space (CGColorSpace). Pass nil for images that don’t contain color data (such as elevation maps, normal vector maps, and sampled function tables).
      // Fixme: ⚠️️ convert to grayscale instead, its prob faster
      var bitmapInfo: UInt32 = CGBitmapInfo.byteOrder32Big.rawValue
      bitmapInfo |= CGImageAlphaInfo.premultipliedLast.rawValue & CGBitmapInfo.alphaInfoMask.rawValue
      let bytesPerRow: Int = rgbaImage.width * 4 //((The number of bytes per row.
      
      
      
//      let ciContext: CIContext = .init()
//      ciContext.
      let data = Data(buffer: rgbaImage.pixels) // The bitmap data to use for the image. The data you supply must be premultiplied.
      let size: CGSize = .init(width: rgbaImage.size.width, height: rgbaImage.size.height)
      let format: CIFormat = .BGRA8 // A pixel format constant. See Pixel Formats.
      // try setting colorSpace to nil
      let ciImg = CIImage(bitmapData: data, bytesPerRow: bytesPerRow, size: size, format: format, colorSpace: colorSpace)
      // maybe try: init?(bitmapImageRep: NSBitmapImageRep)
      return ciImg
//      guard let imageContext = CGContext(data: rgbaImage.pixels.baseAddress, width: rgbaImage.width, height: rgbaImage.height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo, releaseCallback: nil, releaseInfo: nil) else { throw NSError(domain: "Unable to create imageContext", code: 0) }
//      guard let cgImage: CGImage = imageContext.makeImage() else { throw NSError(domain: "Unable to create cgImage", code: 0) }
//      return cgImage
//      CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
//      CIImage *cameraImage = [[CIImage alloc] initWithCVPixelBuffer:pixelBuffer];
//      CGColorSpaceRef cSpace = CGColorSpaceCreateDeviceRGB();
//      cameraImage = [self.logoImage imageByCompositingOverImage:cameraImage];
//      [self.context render:cameraImage toCVPixelBuffer:pixelBuffer bounds:cameraImage.extent colorSpace:cSpace];
   }
   
   /**
    * new
    */
   static func ciImg2(rgbaImage: RGBAImage) -> CIImage? {
      let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceRGB() // The color space that the image is defined in. It must be a Quartz 2D color space (CGColorSpace). Pass nil for images that don’t contain color data (such as elevation maps, normal vector maps, and sampled function tables).
      let data: Data = Data(buffer: rgbaImage.pixels)
      let cfdata = NSData(data: data) as CFData
      guard let provider: CGDataProvider = CGDataProvider(data: cfdata) else { print("CGDataProvider is not supposed to be nil"); return nil }
      let format: CIFormat = .BGRA8 // A pixel format constant. See Pixel Formats.
      let capacity: Int = rgbaImage.size.width * rgbaImage.size.height
//      (imageProvider: , size: rgbaImage.size, format: format, colorSpace: colorSpace, options: nil) // Initializes an image object with data provided by an image provider, using the specified options.
      let ciImage = CIImage.init(imageProvider: provider, size: capacity, rgbaImage.size.height, format: format, colorSpace: colorSpace, options: nil)
      return ciImage
   }
}

// things to try: ⚠️️

//init(cvImageBuffer: CVImageBuffer)
//Initializes an image object from the contents of a Core Video image buffer.
//
//init(cvImageBuffer: CVImageBuffer, options: [CIImageOption : Any]?)
//Initializes an image object from the contents of a Core Video image buffer, using the specified options.
//
//init(cvPixelBuffer: CVPixelBuffer)
//Initializes an image object from the contents of a Core Video pixel buffer.
//
//init(cvPixelBuffer: CVPixelBuffer, options: [CIImageOption : Any]?)
//Initializes an image object from the contents of a Core Video pixel buffer using the specified options.
//
//init?(data: Data)
//Initializes an image object with the supplied image data.
//
//init?(data: Data, options: [CIImageOption : Any]?)
//Initializes an image object with the supplied image data, using the specified options.
//
//init(imageProvider: Any, size: Int, Int, format: CIFormat, colorSpace: CGColorSpace?, options: [CIImageOption : Any]?)
//Initializes an image object with data provided by an image provider, using the specified options.



// Fixme: ⚠️️ you could try the bellow and see if its faster?
//struct PixelData {
//   var a: UInt8 = 0
//   var r: UInt8 = 0
//   var g: UInt8 = 0
//   var b: UInt8 = 0
//}
//
//func imageFromBitmap(pixels: [PixelData], width: Int, height: Int) -> UIImage? {
//   assert(width > 0)
//   
//   assert(height > 0)
//   
//   let pixelDataSize = MemoryLayout<PixelData>.size
//   assert(pixelDataSize == 4)
//   
//   assert(pixels.count == Int(width * height))
//   
//   let data: Data = pixels.withUnsafeBufferPointer {
//      return Data(buffer: $0)
//   }
//   
//   let cfdata = NSData(data: data) as CFData
//   let provider: CGDataProvider! = CGDataProvider(data: cfdata)
//   if provider == nil {
//      print("CGDataProvider is not supposed to be nil")
//      return nil
//   }
//   let cgimage: CGImage! = CGImage(
//      width: width,
//      height: height,
//      bitsPerComponent: 8,
//      bitsPerPixel: 32,
//      bytesPerRow: width * pixelDataSize,
//      space: CGColorSpaceCreateDeviceRGB(),
//      bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue),
//      provider: provider,
//      decode: nil,
//      shouldInterpolate: true,
//      intent: .defaultIntent
//   )
//   if cgimage == nil {
//      print("CGImage is not supposed to be nil")
//      return nil
//   }
//   return UIImage(cgImage: cgimage)
//}
