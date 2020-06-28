import Foundation

class PixelModifier {
   /**
    * - Note: Used by the Compositor class
    * - - Note: ⚠️️ This is kept around because we need to use similar code when doing more advance similarity testing etc
    * - Note: you also have subtractingReportingOverflow and for divide and multiply
    */
   static func applyPixel(first: Pixel, second: Pixel, alpha: UInt8) {
      var newPixel: Pixel = .init(r: 0, g: 0, b: 0, a: 0)
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
