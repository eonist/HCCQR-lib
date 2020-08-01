import Foundation
/**
 * Pixel (stores a color for a pixel in the red,green, blue channels)
 * - Fixme: ⚠️️⚠️️⚠️️ get rid of alpha, because there is no alpha, just be careful that you don't ruin the conversion methods that rely on struct being what it is etc
 * - Fixme: ⚠️️ simplify Pixel, by moving code out of it, and into parsers, asserters and modifiers
 */
public struct Pixel: PixelDataKind {
   public let r: UInt8
   public let g: UInt8
   public let b: UInt8
   public let a: UInt8 = 255
   public init(r: UInt8, g: UInt8, b: UInt8/*, a: UInt8 = 255*/) {
      self.r = r
      self.g = g
      self.b = b
   }
}
