import Foundation
import QuartzCore
import CoreImage
/**
 * - Fixme: ⚠️️ clean up some of these methods, or delete them etc
 */
public final class RGBARepParser {
   /**
    * Converts rgbaImage to uiimage / nsimage
    * - Parameter scale: the amount to scale the image by (screenScale)
    * - Note: used by the colorize process
    */
   static func image(rgbaImage: RGBARep, scale: CGFloat) throws -> Image {
      try autoreleasepool { // Ref: ⚠️️ https://stackoverflow.com/questions/25860942/is-it-necessary-to-use-autoreleasepool-in-a-swift-program
         let cgImage: CGImage = try RGBARepParser.cgImage(rgbaImage: rgbaImage)
         return ImageUtil.image(cgImage: cgImage, scale: scale) // Convert CGImage to UIImage
      }
   }
}
/**
 * Private static helper method
 */
extension RGBARepParser {
   /**
    * Converts rgbaImage to cgImage (works I guess)
    * - Note: alternative data -> img code, might be faster?: https://stackoverflow.com/questions/51372245/swift-covert-byte-array-into-ciimage
    */
   private static func cgImage(rgbaImage: RGBARep, useGrayscale: Bool = false) throws -> CGImage {
      // We use autorelease Because CoreGraphics is not handled by ARC (like all other C libraries),
      // you need to wrap your code with with an autorelease, even in Swift.
      // Particularly if you are not on the main thread (which you should not be, if CoreGraphics is involved... .userInitiated or lower is appropriate).
      return try autoreleasepool {  // ⚠️️ testing to get rid of mem leak ⚠️️ new
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
         return cgImage/*useGrayscale ? convertToGrayScale(cgImage: cgImage) : */
      }
   }
   /**
    * Experimental (⚠️️ Not working, not used by anything ⚠️️)
    */
   private static func ciImg(rgbaImage: RGBARep) -> CIImage {
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
    * RGBAImage -> CIImage (New)
    * - Fixme: ⚠️️ Make the grayscale work, see similar solution as convertToGrayscale use
    * - Note: The composite method uses this method
    * - Note: Basically monotone not grayscale
    */
   static func ciImg2(rgbaImage: RGBARep, useGrayscale: Bool) throws -> CIImage {
//      Swift.print("ciImg2")
      let format: CIFormat = .RGBA8 //.BGRA8 // .RGBA8// .ARGB8//.ABGR8// // A pixel format constant. See Pixel Formats.
      let colorSpace: CGColorSpace = useGrayscale ? CGColorSpaceCreateDeviceGray() : CGColorSpaceCreateDeviceRGB()//CGColorSpaceCreateDeviceRGB() // The color space that the image is defined in. It must be a Quartz 2D color space (CGColorSpace). Pass nil for images that don’t contain color data (such as elevation maps, normal vector maps, and sampled function tables).
      let bytesPerRow: Int = rgbaImage.size.width * 4
      let data: Data = .init(buffer: rgbaImage.pixels)
      let ciImg: CIImage = .init(bitmapData: data, bytesPerRow: bytesPerRow, size: CGSize(width: CGFloat(rgbaImage.size.width), height: CGFloat(rgbaImage.size.height)), format: format, colorSpace: colorSpace)
      return ciImg
   }
   /**
    * ⚠️️Untested ⚠️️
    * ref: https://stackoverflow.com/a/51380146/5389500 (also has pointer while loop)
    */
   func ciImg3(rgbaImage: RGBARep) -> CIImage? {
      // 4 bytes(rgba channels) for each pixel
      let bytesPerPixel: Int = 4
      // (8 bits per each channel)
      //      let bitsPerComponent: Int = 8
      //      let bitsPerPixel = bytesPerPixel * bitsPerComponent;
      // channels in each row (width)
      let (w, h): (Int, Int) = (rgbaImage.size.width, rgbaImage.size.height)
      //      let bytesPerRow: Int = w * bytesPerPixel;
      //      let data: Data = .init(buffer: rgbaImage.flatPixels)
      let cfData = CFDataCreate(nil, rgbaImage.flatPixels, w * h * bytesPerPixel)
      let cgDataProvider = CGDataProvider(data: cfData!)!
      let format: CIFormat = .RGBA8 //.BGRA8 // .RGBA8// .ARGB8//.ABGR8// // A pixel format constant. See Pixel Formats.
      let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceRGB()//useGrayscale ? CGColorSpaceCreateDeviceGray() : CGColorSpaceCreateDeviceRGB()//CGColorSpaceCreateDeviceRGB() // The color space that the image is defined in. It must be a Quartz 2D color space (CGColorSpace). Pass nil for images that don’t contain color data (such as elevation maps, normal vector maps, and sampled function tables).
      return .init(imageProvider: cgDataProvider, size: rgbaImage.size.width, rgbaImage.size.height, format: format, colorSpace: colorSpace, options: nil)
   }
   /**
    *
    */
//   static func grayScaleCIImg(rgbaImage: RGBAImage, useGrayscale: Bool/*, opaque: Bool, scale: Int = 1*/ ) throws -> CIImage {
//      Swift.print("grayScaleCIImg")
//      let data: Data = .init(buffer: rgbaImage.pixels)
//      let format: CIFormat = .RGBA8 //.BGRA8 // .RGBA8// .ARGB8//.ABGR8// // A pixel format constant. See Pixel Formats.
//      let colorSpace: CGColorSpace = useGrayscale ? CGColorSpaceCreateDeviceGray() : CGColorSpaceCreateDeviceRGB()//CGColorSpaceCreateDeviceRGB() // The color space that the image is defined in. It must be a Quartz 2D color space (CGColorSpace). Pass nil for images that don’t contain color data (such as elevation maps, normal vector maps, and sampled function tables).
//      let bytesPerPixel: Int = 4//opaque ? 1 : 2
//      let bytesPerRow: Int = bytesPerPixel * rgbaImage.width /* scale*/// * imageRect.image.scale
//      let ciImg: CIImage = .init(bitmapData: data, bytesPerRow: bytesPerRow, size: CGSize(width: CGFloat(rgbaImage.size.width), height: CGFloat(rgbaImage.size.height)), format: format, colorSpace: colorSpace)
//      return ciImg
//   }
//   let imageRect: CGRect = .init(x: 0, y: 0, width: cgImage.width, height: cgImage.height) // Create image rectangle with current image width/height
//   let colorSpace = CGColorSpaceCreateDeviceGray() // Grayscale color space
//   let bitsPerComponent = 8
//   let bytesPerPixel: Int = opaque ? 1 : 2
//   let bytesPerRow: Int = bytesPerPixel * cgImage.width * scale// * imageRect.image.scale
//   Swift.print("bytesPerRow:  \(bytesPerRow)")
//   let bitmapInfo = opaque ? CGImageAlphaInfo.none.rawValue : CGImageAlphaInfo.premultipliedLast.rawValue
//   guard let context = CGContext(data: nil, width: cgImage.width, height: cgImage.height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo) else { throw NSError(domain: "Unable to create context", code: 0) }
//   context.draw(cgImage, in: imageRect) // // Using previously defined context (with grayscale colorspace)
//   guard let cgImg = context.makeImage() else { throw NSError(domain: "unable to makeImage", code: 0) }// Create bitmap image info from pixel data in current context
//   debugCGImage(cgImage: cgImg)
//   return cgImg
   /**
    * ref https://developer.apple.com/documentation/coreimage/cicontext/1437897-render
    * The idea with this method is to convert RGBAImage.pixels into CICOntext, and use apples QR reader directly with the CIContext, instead of cIimage
    */
   static func ciContext(rgbaImage: RGBARep) {
      //
//      CIContext.render(_ image: CIImage,
//             toBitmap data: UnsafeMutableRawPointer,
//         rowBytes: Int,
//         bounds: CGRect,
//         format: CIFormat,
//         colorSpace: CGColorSpace?)
   }
}
//      Parameters
//      p
//      A data provider that implements the CIImageProvider informal protocol. Core Image maintains a strong reference to this object until the image is deallocated.
//
//      width
//      The width of the image data.
//
//      height
//      The height of the image data.
//
//      f
//      A pixel format constant. See Pixel Formats.
//
//      cs
//      The color space of the image. If this value is nil, the image is not color matched. Pass nil for images that don’t contain color data (such as elevation maps, normal vector maps, and sampled function tables).
//
//      dict
//      A dictionary that specifies image-creation options, either kCIImageProviderTileSize or kCIImageProviderUserInfo. See CIImageProvider for more information on these options.


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
/**
 * RGBAImage -> CIImage
 * - Note: The composite method uses this method
 */
//   private func ciImage(rgbaImage: RGBAImage) throws -> CIImage {
//      // - Fixme: ⚠️️ implement the grayscale
//      guard let ciImage: CIImage = try? ciImg2(rgbaImage: rgbaImage) else { throw NSError(domain: "err getting ciimg", code: 0) }
//      return ciImage
////      let cgImage: CGImage = try RGBAImageUtil.cgImage(rgbaImage: rgbaImage, useGrayscale: true)
////      return cgImage.ciImage() // we convert to CIImage here, because apples QRReader reades CIImage
//      //      return CIImage(cgImage: cgImage, options: [CIImageOption.colorSpace: CGColorSpaceCreateDeviceGray()])
//      // Fixme: ⚠️️ we can prob create ciImage directly for better speed, see RGBKit and related research
////      return ciImg(rgbaImage: rgbaImage)
//   }
