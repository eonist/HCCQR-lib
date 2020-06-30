import Foundation
/**
 * New
 */
extension GrayscaleRep {
   internal typealias FunctorCall = ((Pixel) -> UInt8)
   internal typealias FunctorIndexCall = ((Int, UInt8) -> UInt8)
}
