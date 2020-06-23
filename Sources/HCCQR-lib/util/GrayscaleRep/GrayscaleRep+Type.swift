import Foundation
/**
 * New
 */
extension GrayscaleRep {
   internal typealias Size = (width: Int, height: Int)
   internal typealias FunctorCall = ((Pixel) -> UInt8)
   internal typealias FunctorIndexCall = ((Int, UInt8) -> UInt8)
}
