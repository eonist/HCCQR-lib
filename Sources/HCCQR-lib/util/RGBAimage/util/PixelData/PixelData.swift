import Foundation
/**
 * PixelData (holds a color for a pixel)
 * - Fixme: ⚠️️ Rename to Pixel again?
 */
struct PixelData {
   var r: UInt8
   var g: UInt8
   var b: UInt8
   var a: UInt8
}
// ⚠️️ consider doing this data structur, might be faster

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
