import Foundation
import CoreImage
/**
 * Private static helper
 */
extension RGBARep {
   /**
    * Creates the correct bitmapInfo
    * - Note: used by RGBA+Init method
    */
   internal static var bitmapInfo: UInt32 {
      var bitmapInfo: UInt32 = CGBitmapInfo.byteOrder32Big.rawValue // BGRA
      // - Fixme: ⚠️️ could be that we can to nonSkip lat etc
      bitmapInfo = bitmapInfo | CGImageAlphaInfo.premultipliedLast.rawValue & CGBitmapInfo.alphaInfoMask.rawValue
      return bitmapInfo
   }
}
