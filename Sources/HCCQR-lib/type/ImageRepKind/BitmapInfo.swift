import Foundation
import CoreImage
/**
 * Private static helper
 */
final class BitmapInfo {
   /**
    * Creates the correct bitmapInfo
    * - Note: used by RGBA+Init method
    * - Note: works for converting image to data, we use a different bitmapInfo for converting data to image
    * - Fixme: ⚠️️ possibly rename to readBitMapData, and then make one for writeBitmapData
    */
   internal static var bitmapInfo: UInt32 {
      var bitmapInfo: UInt32 = CGBitmapInfo.byteOrder32Big.rawValue // BGRA
      // - Fixme: ⚠️️ could be that we can to nonSkip lat etc
      bitmapInfo = bitmapInfo | CGImageAlphaInfo.premultipliedLast.rawValue & CGBitmapInfo.alphaInfoMask.rawValue
      return bitmapInfo
   }
}
