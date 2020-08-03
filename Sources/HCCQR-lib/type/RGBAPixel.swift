import Foundation
/**
 * Only used to convert Image to ImageRep
 */
internal struct RGBAPixel {
   internal let r: UInt8
   internal let g: UInt8
   internal let b: UInt8
   internal let a: UInt8
}
/**
 * Getter
 */
extension RGBAPixel {
   var isWhite: Bool {
      r == 255 && g == 255 && b == 255
   }
   var pixel: Pixel {
      .init(r: self.r, g: self.g, b: self.b)
   }
}
