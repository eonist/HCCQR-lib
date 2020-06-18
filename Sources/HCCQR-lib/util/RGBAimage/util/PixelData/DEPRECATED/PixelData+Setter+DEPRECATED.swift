import Foundation
/**
 * Setter
 */
extension Pixel {
   /**
    * ⚠️️⚠️️⚠️️ DEPRECATED ⚠️️⚠️️⚠️️
    * - Note: Used by the Compositor class
    * - - Fixme: ⚠️️⚠️️⚠️️ May not be needed anymore, since pixels are not over-written
    * - Note: you also have subtractingReportingOverflow and for divide and multiply
    */
   mutating func applyPixel(first: Pixel, second: Pixel, alpha: UInt8) {
      self.r = {
         let wrapAdd = first.r.addingReportingOverflow(second.r)
         return wrapAdd.overflow ? 255 : wrapAdd.partialValue
      }()
      self.g = {
         let wrapAdd = first.g.addingReportingOverflow(second.g)
         return wrapAdd.overflow ? 255 : wrapAdd.partialValue
      }()
      self.b = {
         let wrapAdd = first.b.addingReportingOverflow(second.b)
         return wrapAdd.overflow ? 255 : wrapAdd.partialValue
      }()
      self.a = alpha // if first.a < 255 {}
   }
}
/**
 * Convenience
 */
extension Pixel {
   /**
    * ⚠️️⚠️️⚠️️ DEPRECATED ⚠️️⚠️️⚠️️
    * Inverted (only works for pure black or pure white pixels)
    * - Note: used in the composite method
    */
   func inverted() -> Pixel {
      self.isWhite ? Colors.blackPixel : Colors.whitePixel
   }
}
