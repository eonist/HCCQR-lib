import Foundation
import CoreImage
/**
 * Private static helper
 */
extension GrayscaleImage {
   /**
    * Creates the correct bitmapInfo
    */
   private static var bitmapInfo: UInt32 {
      var bitmapInfo: UInt32 = CGBitmapInfo.byteOrder32Big.rawValue // BGRA
      bitmapInfo = bitmapInfo | CGImageAlphaInfo.premultipliedLast.rawValue & CGBitmapInfo.alphaInfoMask.rawValue
      return bitmapInfo
   }
}

/**
 * deprecated
 */
//extension GrayscaleImage {
/**
 * CIImage -> GrayscaleImage (⚠️️ new, untested ⚠️️)
 * - Note: Seems to be slightly faster than converting ciimage to cgimage etc
 * - Note: ref https://www.geekspiff.com/unlinkedCrap/ciImageToBitmap.html
 */
//   private static func grayscaleImage(ciImg: CIImage) throws -> GrayscaleImage {
//      Swift.print("grayscaleImage.start")
//      Swift.print("ciImg.debugDescription:  \(ciImg.debugDescription)")
//      let bitMapInfo = GrayscaleImage.bitmapInfo
//      let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceGray()
//      let size: Size = (width: Int(ciImg.extent.width), height: Int(ciImg.extent.height))
//      let capacity: Int = size.width * size.height
//      let bytesPerRow: Int = size.width * 1 // We multiply per 1 because of the 1 channels, grayscale
//      let imageData = UnsafeMutablePointer<UInt8>.allocate(capacity: capacity)
//      // - Fixme: ⚠️️ Do we have to create the cgContext? can CIContext be created directly from pixeldata?
//      let bitsPerComponent = 8 // - Fixme: ⚠️️ this could be 2, when its grayscale?
//      guard let cgContext = CGContext(data: imageData, width: size.width, height: size.height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitMapInfo) else { throw NSError(domain: "rgbaImage - Unable to create rgbaImage", code: 0) }
//      let context: CIContext = .init(cgContext: cgContext, options: nil) // .init(options: nil)// = CIContext.init(cgContext: , options: )
//      context.draw(ciImg, in: ciImg.extent, from: ciImg.extent)
//      let pixels = UnsafeMutableBufferPointer<UInt8>(start: imageData, count: capacity)
//      Swift.print("grayscaleImage.end")
//      return .init(pixels: pixels, width: size.width, height: size.height)
//   }
//}
