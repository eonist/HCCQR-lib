import Foundation
/**
 * - Fixme: ⚠️️ add doc
 */
extension RGBAImage {
   internal typealias FunctorCall = ((PixelData) -> PixelData)
   internal typealias FunctorIndexCall = ((Int, PixelData) -> PixelData)
   /**
    * Convenient
    */
   internal typealias Size = (width: Int, height: Int)
}
