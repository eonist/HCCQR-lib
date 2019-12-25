import Foundation
import QuartzCore
import CoreImage

public final class RGBAImageUtil {
   /**
    * Converts rgbaImage to uiimage / nsimage
    * - Parameter scale: the amount to scale the image by (screenScale)
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
      let cgImage: CGImage = try RGBAImageUtil.cgImage(rgbaImage: rgbaImage )
      // Fixme: ⚠️️ we can prob create ciImage directly for better speed, see RGBKit and related research
      return cgImage.ciImage() // we convert to CIImage here, because apples QRReader reades CIImage
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
   private static func cgImage(rgbaImage: RGBAImage) throws -> CGImage {
      let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceRGB()
      // Fixme: ⚠️️ convert to grayscale instead, its prob faster
      var bitmapInfo: UInt32 = CGBitmapInfo.byteOrder32Big.rawValue
      let bytesPerRow: Int = rgbaImage.width * 4
      bitmapInfo |= CGImageAlphaInfo.premultipliedLast.rawValue & CGBitmapInfo.alphaInfoMask.rawValue
      guard let imageContext = CGContext(data: rgbaImage.pixels.baseAddress, width: rgbaImage.width, height: rgbaImage.height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo, releaseCallback: nil, releaseInfo: nil) else { throw NSError(domain: "Unable to create imageContext", code: 0) }
      guard let cgImage: CGImage = imageContext.makeImage() else { throw NSError(domain: "Unable to create cgImage", code: 0) }
      return cgImage
   }
}
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
