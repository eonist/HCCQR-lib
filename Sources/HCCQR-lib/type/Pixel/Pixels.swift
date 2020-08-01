import Foundation

public typealias Pixels = [PixelData]

extension Pixels {
   /**
    * Creates multiple evenly spread colors in various ranges
    * - Note: Examples of ranges include: 4,8,16,32,64,128,256..etc colors
    * - Note: Used by ChannelScheme etc
    * ## Examples:
    * Pixels.dynamicColors(r: 4, g: 2, b: 2) // 16 colors
    * - Parameters:
    *   - r: num of reds
    *   - g: num of greens
    *   - b: num of blues
    */
   static func dynamicColors(r: UInt8, g: UInt8, b: UInt8) -> [PixelData] {
      let rArr: [UInt8] = channels(count: r)
      let gArr: [UInt8] = channels(count: g)
      let bArr: [UInt8] = channels(count: b)
      return rArr.flatMap { (r: UInt8) in
         gArr.flatMap { (g: UInt8) in
            bArr.map { (b: UInt8) in
               PixelData(r: r, g: g, b: b/*, a: 255*/)
            }
         }
      }
   }
}
/**
 * Private static helper method
 */
extension Pixels {
   /**
    * Creates an evenly spread range of values between 0 and 255
    * ## Examples:
    * channel(count: 4) // [255, 170, 85, 0]
    * - Parameter count: num of channels
    */
   private static func channels(count: UInt8) -> [UInt8] {
      (0..<count).reversed().map { $0 * (UInt8(255) / (count - 1)) }
   }
}
