import Foundation
/**
 * New
 */
extension GrayscaleImage {
   internal typealias Size = (width: Int, height: Int)
   // - Fixme: ⚠️️ rename to Functorcall etc
   internal typealias GrayScaleFunctorCall = ((Pixel) -> UInt8)
   internal typealias GrayScaleFunctorIndexCall = ((Int, UInt8) -> UInt8)
}
