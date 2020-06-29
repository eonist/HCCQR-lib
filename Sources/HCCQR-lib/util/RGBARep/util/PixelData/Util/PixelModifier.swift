import Foundation

class PixelModifier {
   /**
    * - Note: Used by the Compositor class
    * - Note: ⚠️️ This is kept around because we need to use similar code when doing more advance similarity testing etc
    * - Note: you also have subtractingReportingOverflow and for divide and multiply
    * - Fixme: ⚠️️ Deprecate soon, its not in use
    * - Parameters:
    *   - first: the old pixel
    *   - second: the new pixel to apply to the old
    *   - alpha: ?
    */
   private static func applyPixel(first: Pixel, second: Pixel, alpha: UInt8) {
      var newPixel: Pixel = .empty
      newPixel.r = {
         let wrapAdd = first.r.addingReportingOverflow(second.r)
         return wrapAdd.overflow ? 255 : wrapAdd.partialValue
      }()
      newPixel.g = {
         let wrapAdd = first.g.addingReportingOverflow(second.g)
         return wrapAdd.overflow ? 255 : wrapAdd.partialValue
      }()
      newPixel.b = {
         let wrapAdd = first.b.addingReportingOverflow(second.b)
         return wrapAdd.overflow ? 255 : wrapAdd.partialValue
      }()
      newPixel.a = alpha // if first.a < 255 {}
   }
}
