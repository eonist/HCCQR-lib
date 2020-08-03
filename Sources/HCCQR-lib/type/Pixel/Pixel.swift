import Foundation
/**
 * Pixel (stores a color for a pixel in the red,green, blue channels)
 * - Fixme: ⚠️️ simplify Pixel, by moving code out of it, and into parsers, asserters and modifiers
 */
public struct Pixel {
   public let r: UInt8
   public let g: UInt8
   public let b: UInt8
}
