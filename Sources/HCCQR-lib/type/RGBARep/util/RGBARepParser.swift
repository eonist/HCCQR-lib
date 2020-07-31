import Foundation
import QuartzCore
import CoreImage
import TimeMeasure

public final class RGBARepParser {
   /**
    * Converts rgbaImage to uiimage / nsimage
    * - Note: this method is blazing fat, no need to optimize
    * - Note: used by the colorize process and Write.image method
    * - Note: regarding autorelease: https://stackoverflow.com/questions/25860942/is-it-necessary-to-use-autoreleasepool-in-a-swift-program
    * - Parameters:
    *   - scale: the amount to scale the image by (screenScale)
    *   - rgbaImage: rgbaRep to convert to image
    */
   static func image(rgbaRep: RGBARep, scale: CGFloat) throws -> Image {
      let cgImg: CGImage = try cgImage(rgbaRep: rgbaRep)
      return ImageUtil.image(cgImage: cgImg, scale: scale) // Embed CGImage in UIImage (very fast, not worth speed testing, basically just adds metadata to cgimg)
   }
   /**
    * RGBAImage -> CIImage
    * - Fixme: ⚠️️ Make the grayscale work, see similar solution as convertToGrayscale use
    * - Note: The composite method uses this method
    * - Note: Basically monotone not grayscale
    * - Note: Used by colorizer method
    * ref https://developer.apple.com/documentation/coreimage/cicontext/1437897-render
    * https://www.geekspiff.com/unlinkedCrap/ciImageToBitmap.html
    * ref: https://stackoverflow.com/a/51380146/5389500 (also has pointer while loop)
    */
   static func ciImg2(rgbaRep: RGBARep, useGrayscale: Bool) throws -> CIImage {
      // Swift.print("ciImg2")
//      return autoreleasepool { // ⚠️️ testing to get rid of mem leak ⚠️️ new, doesnt seem to have much effect
      let format: CIFormat = .RGBA8 //.BGRA8 // .RGBA8// .ARGB8//.ABGR8// // A pixel format constant. See Pixel Formats.
      // new ⚠️️ 
      let colorSpace: CGColorSpace = useGrayscale ? CGColorSpaceCreateDeviceGray() : CGColorSpaceCreateDeviceRGB()//CGColorSpaceCreateDeviceRGB() // The color space that the image is defined in. It must be a Quartz 2D color space (CGColorSpace). Pass nil for images that don’t contain color data (such as elevation maps, normal vector maps, and sampled function tables).
      let bytesPerRow: Int = rgbaRep.size.width * 4
      let data: Data = .init(buffer: rgbaRep.pixels)
      let ciImg: CIImage = .init(bitmapData: data, bytesPerRow: bytesPerRow, size: CGSize(width: CGFloat(rgbaRep.size.width), height: CGFloat(rgbaRep.size.height)), format: format, colorSpace: colorSpace)
      return ciImg
//      }
   }
}
/**
 * Private static helper method
 */
extension RGBARepParser {
   /**
    * rgbaRep 👉 cgImage
    * - Fixme: ⚠️️ Try making CIImage from rgb without alpha
    * - Fixme: ⚠️️ Try the CIImage conversions as well, might be even faster?
    * - Fixme: ⚠️️ Make custom Error types for the erros this method can throw 👈
    * - Note: this method is much faster than the slow version of this where you use: CGContext().makeImage() etc
    * - Note: alternative data -> img code, might be faster?: https://stackoverflow.com/questions/51372245/swift-covert-byte-array-into-ciimage (this recuires .flatPixels)
    * - Note: We use autorelease Because CoreGraphics is not handled by ARC (like all other C libraries),
    * - Note: you need to wrap your code with with an autorelease, even in Swift.
    * - Note: Particularly if you are not on the main thread (which you should not be, if CoreGraphics is involved... .userInitiated or lower is appropriate).
    * - Note: use CGImageAlphaInfo.premultipliedFirst if argb
    * - Parameter rgbaRep: The rep to convert into cgImage
    */
   internal static func cgImage(rgbaRep: RGBARep) throws -> CGImage {
//    try autoreleasepool {  // ⚠️️ testing to get rid of mem leak ⚠️️
      let deviceColorSpace: CGColorSpace = CGColorSpaceCreateDeviceRGB()
      let bitmapInfo: CGBitmapInfo = .init(rawValue: CGBitmapInfo.byteOrder32Big.rawValue | CGImageAlphaInfo.noneSkipLast.rawValue) // premultipliedLast also works
//    var bitmapInfo: UInt32 = CGBitmapInfo.byteOrder32Big.rawValue
//    bitmapInfo |= CGImageAlphaInfo.premultipliedLast.rawValue & CGBitmapInfo.alphaInfoMask.rawValue
      let bytesPerRow: Int = rgbaRep.width * MemoryLayout<Pixel>.size // channels in each row (width)
      let bitsPerComponent: Int = 8 // (8 bits per each channel)
      let bytesPerPixel: Int = 4 // 4 bytes(rgba channels) for each pixel
      let bitsPerPixel: Int = bytesPerPixel * bitsPerComponent
      let flatPixels = rgbaRep.flatPixels
      defer { flatPixels.deallocate() } // we have no use for flatPixels after image is returned
      guard let cfData = CFDataCreate(nil, flatPixels, rgbaRep.width * rgbaRep.height * bytesPerPixel) else { throw CGImageErr.unableToCreateCFData }
      guard let cgDataProvider = CGDataProvider(data: cfData) else { throw CGImageErr.unableToCreateCGDataProvider }
      guard let image = CGImage(width: rgbaRep.width, height: rgbaRep.height, bitsPerComponent: bitsPerComponent, bitsPerPixel: bitsPerPixel, bytesPerRow: bytesPerRow, space: deviceColorSpace, bitmapInfo: bitmapInfo, provider: cgDataProvider, decode: nil, shouldInterpolate: true, intent: .defaultIntent) else { throw CGImageErr.unableToCreateCGImage }
      return image
//      }
   }
}
/**
 * Error
 */
extension RGBARepParser {
   internal enum CGImageErr: Error {
      case unableToCreateCFData
      case unableToCreateCGDataProvider
      case unableToCreateCGImage
   }
}
