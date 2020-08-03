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
   /**
    * Assert if rgbaPixel is pure white
    */
   var isWhite: Bool {
      r == 255 && g == 255 && b == 255
   }
   /**
    * Convert to Pixel type
    */
   var pixel: Pixel {
      .init(r: self.r, g: self.g, b: self.b)
   }
}
