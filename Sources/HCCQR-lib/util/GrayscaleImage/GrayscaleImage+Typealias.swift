import Foundation
/**
 * New
 */
extension GrayscaleImage {
   internal typealias Size = (width: Int, height: Int)
   internal typealias GrayScaleFunctorCall = ((Pixel) -> UInt8)
   internal typealias GrayScaleFunctorIndexCall = ((Int, UInt8) -> UInt8)
}
