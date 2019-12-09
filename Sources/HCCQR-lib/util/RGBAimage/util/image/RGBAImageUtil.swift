import Foundation
import QuartzCore
import CoreImage

public class RGBAImageUtil {
   /**
    * Converts rgbaImage to uiimage / nsimage
    * - Parameter scale: the amount to scale the image by (screenScale)
    */
   static func image(rgbaImage: RGBAImage, scale: CGFloat) throws -> Image {
      let cgImage: CGImage = try RGBAImageUtil.cgImage(rgbaImage: rgbaImage)
      return ImageUtil.image(cgImage: cgImage, scale: scale) // Convert CGImage to UIImage
   }
   /**
    * Convenience
    */
   static func ciImage(rgbaImage: RGBAImage ) throws -> CIImage {
      let cgImage: CGImage = try RGBAImageUtil.cgImage(rgbaImage: rgbaImage )
      return cgImage.ciImage()
   }
   /**
    * Converts rgbaImage to cgImage
    * - Note: alternative data -> img code, might be faster?: https://stackoverflow.com/questions/51372245/swift-covert-byte-array-into-ciimage
    */
   static func cgImage(rgbaImage: RGBAImage ) throws -> CGImage {
      let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceRGB()
      var bitmapInfo: UInt32 = CGBitmapInfo.byteOrder32Big.rawValue
      let bytesPerRow: Int = rgbaImage.width * 4
      bitmapInfo |= CGImageAlphaInfo.premultipliedLast.rawValue & CGBitmapInfo.alphaInfoMask.rawValue
      guard let imageContext = CGContext(data: rgbaImage.pixels.baseAddress, width: rgbaImage.width, height: rgbaImage.height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo, releaseCallback: nil, releaseInfo: nil) else { throw NSError.init(domain: "Unable to create imageContext", code: 0) }
      guard let cgImage: CGImage = imageContext.makeImage() else { throw NSError.init(domain: "Unable to create cgImage", code: 0) }
      return cgImage
   }
}

