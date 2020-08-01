import Foundation
import CoreImage
/**
 * Rep
 */
extension ByteImage {
   /**
    * image -> ImageRep
    */
   internal static func imageRep(image: Image) throws -> ImageRepKind {
      guard let cgImg = image.cgImage() else { throw NSError(domain: "rgbaImage - Unable to create rgbaImage", code: 0) }
      return try imageRep(cgImage: cgImg)
   }
}
/**
 * private
 */
extension ByteImage {
   /**
    * cgImage -> ImageRep
    */
   private static func imageRep(cgImage: CGImage) throws -> ImageRepKind {
      let width = Int(cgImage.width)
      let height = Int(cgImage.height)
      let bytesPerRow = width * 4
      let imageData = UnsafeMutablePointer<PixelData>.allocate(capacity: width * height)
      let colorSpace = CGColorSpaceCreateDeviceRGB()
      var bitmapInfo: UInt32 = CGBitmapInfo.byteOrder32Big.rawValue
      bitmapInfo = bitmapInfo | CGImageAlphaInfo.premultipliedLast.rawValue & CGBitmapInfo.alphaInfoMask.rawValue
      guard let imageContext = CGContext(data: imageData, width: width, height: height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo) else { throw NSError(domain: "rgbaImage - Unable to create rgbaImage", code: 0) }
      imageContext.draw(cgImage, in: CGRect(origin: .zero, size: .init(width: CGFloat(cgImage.width), height: CGFloat(cgImage.height))))
      //      pixels = UnsafeMutableBufferPointer<BytePixel>(start: imageData, count: width * height)
      let pixis: UnsafeBufferPointer<PixelData> = .init(start: imageData, count: width * height)
      return ByteImage(pixels: pixis, width: width, height: height)
   }
}
