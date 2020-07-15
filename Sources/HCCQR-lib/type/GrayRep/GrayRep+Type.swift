import Foundation
/**
 * For processing
 */
extension GrayRep {
   internal typealias FunctorRGBA = ((Pixel) -> UInt8)
   internal typealias FunctorIndexGray = ((Int, UInt8) -> UInt8)
}
