import Foundation
import CoreImage
/**
 * Private static helper
 */
extension RGBAImage {
   /**
    * Creates the correct bitmapInfo
    */
   static var bitmapInfo: UInt32 {
      var bitmapInfo: UInt32 = CGBitmapInfo.byteOrder32Big.rawValue // BGRA
      bitmapInfo = bitmapInfo | CGImageAlphaInfo.premultipliedLast.rawValue & CGBitmapInfo.alphaInfoMask.rawValue
      return bitmapInfo
   }
}
