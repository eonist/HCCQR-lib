import Foundation
/**
 * New
 */
extension GrayscaleImage {
   internal typealias Size = (width: Int, height: Int)
   // - Fixme: ⚠️️ rename to Functorcall etc
   internal typealias FunctorCall = ((Pixel) -> UInt8)
   internal typealias FunctorIndexCall = ((Int, UInt8) -> UInt8)
}
