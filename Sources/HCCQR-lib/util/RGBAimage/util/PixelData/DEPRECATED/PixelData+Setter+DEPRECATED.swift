import Foundation
/**
 * Setter
 */
extension PixelData {
   /**
    * ⚠️️⚠️️⚠️️ DEPRECATED ⚠️️⚠️️⚠️️
    * - Note: Used by the Compositor class
    * - - Fixme: ⚠️️⚠️️⚠️️ May not be needed anymore, since pixels are not over-written
    */
   mutating func applyPixel(first: PixelData, second: PixelData, alpha: UInt8) {
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
extension PixelData {
   /**
    * ⚠️️⚠️️⚠️️ DEPRECATED ⚠️️⚠️️⚠️️
    * Inverted (only works for pure black or pure white pixels)
    * - Note: used in the composite method
    */
   func inverted() -> PixelData {
      self.isWhite ? Colors.blackPixel : Colors.whitePixel
   }
}
