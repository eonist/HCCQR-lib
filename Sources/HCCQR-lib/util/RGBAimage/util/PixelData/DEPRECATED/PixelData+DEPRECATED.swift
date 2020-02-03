import Foundation
//   /**
//    * Asserts if a pixel is sort of red within a threshold
//    */
//   var isRedish: Bool {
//      return self.isColor(pixel: Colors.redPixel, halfThreshold: PixelData.halfThresholdUInt8)
//   }
//   /**
//    * Asserts if a pixel is sort of green within a threshold
//    */
//   var isGreenish: Bool {
//      return self.isColor(pixel: Colors.greenPixel, halfThreshold: PixelData.halfThresholdUInt8)
//   }
//   /**
//    * Asserts if a pixel is sort of blue within a threshold
//    */
//   var isBlueish: Bool {
//      return self.isColor(pixel: Colors.bluePixel, halfThreshold: PixelData.halfThresholdUInt8)
//   }

//struct Pixel: Equatable {
//   private var rgba: UInt32
//
//   var red: UInt8 {
//      return UInt8((rgba >> 24) & 255)
//   }
//
//   var green: UInt8 {
//      return UInt8((rgba >> 16) & 255)
//   }
//
//   var blue: UInt8 {
//      return UInt8((rgba >> 8) & 255)
//   }
//
//   var alpha: UInt8 {
//      return UInt8((rgba >> 0) & 255)
//   }
//
//   init(red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8) {
//      rgba = (UInt32(red) << 24) | (UInt32(green) << 16) | (UInt32(blue) << 8) | (UInt32(alpha) << 0)
//   }
//
//   static let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Little.rawValue
//
//   static func ==(lhs: Pixel, rhs: Pixel) -> Bool {
//      return lhs.rgba == rhs.rgba
//   }
//}
