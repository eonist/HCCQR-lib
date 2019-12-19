import Foundation
/**
 * Setter
 */
extension PixelData {
   /**
    * - Note: Used by the Compositor class
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
    * Inverted (only works for pure black or pure white pixels)
    * - Note: used in the composite method
    */
   func inverted() -> PixelData {
      return self.isWhite ? Colors.blackPixel : Colors.whitePixel
   }
}
/**
 * Makes pixel black
 */
//   mutating func setBlack() {
//      self.setRGBA(r: 0, g: 0, b: 0, a: 255)
//   }
/**
 * Makes pixel white
 */
//   mutating func setWhite() {
//      self.setRGBA(r: 255, g: 255, b: 255, a: 255)
//   }
/**
 * setPixel (0-255) (⚠️️ not optimized ⚠️️)
 */
//   mutating func setRGBA(r: UInt8, g: UInt8, b: UInt8, a: UInt8) {
//      self.r = r
//      self.g = g
//      self.b = b
//      self.a = a
//   }
