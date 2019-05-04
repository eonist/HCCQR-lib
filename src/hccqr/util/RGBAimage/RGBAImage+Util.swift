import Foundation
/**
 * Class methods
 * - Fixme: ⚠️️ Rename to RGBAImageParser maybe?
 */
extension RGBAImage {
   /**
    * Converts rgbaImage to uiimage / nsimage
    */
   internal static func image(rgbaImage: RGBAImage, scale: CGFloat) -> Image? {
      guard let cgImage: CGImage = cgImage(rgbaImage: rgbaImage ) else { Swift.print("unable to create cgImage"); return nil }
      let image: Image = ImageUtil.image(cgImage: cgImage, scale: scale)/*Convert CGImage to UIImage*/
      return image
   }
   /**
    * Converts rgbaImage to cgImage
    * - Note: alternative data -> img code, might be faster?: https://stackoverflow.com/questions/51372245/swift-covert-byte-array-into-ciimage
    */
   internal static func cgImage(rgbaImage: RGBAImage ) -> CGImage? {
      let colorSpace = CGColorSpaceCreateDeviceRGB()
      var bitmapInfo: UInt32 = CGBitmapInfo.byteOrder32Big.rawValue
      let bytesPerRow = rgbaImage.width * 4
      bitmapInfo |= CGImageAlphaInfo.premultipliedLast.rawValue & CGBitmapInfo.alphaInfoMask.rawValue
      guard let imageContext = CGContext(data: rgbaImage.pixels.baseAddress, width: rgbaImage.width, height: rgbaImage.height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo, releaseCallback: nil, releaseInfo: nil) else { Swift.print("Unable to create imageContext"); return nil }
      guard let cgImage: CGImage = imageContext.makeImage() else { Swift.print("unable to create cgImage"); return nil }
      return cgImage
   }
   /**
    * Convenience
    */
   internal static func ciImage(rgbaImage: RGBAImage ) -> CIImage? {
      guard let cgImage: CGImage = cgImage(rgbaImage: rgbaImage ) else { Swift.print("unable to get cgImage"); return nil }
      return cgImage.ciImage()
   }
}
