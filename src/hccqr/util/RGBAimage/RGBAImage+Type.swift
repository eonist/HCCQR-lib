import Foundation

internal extension RGBAImage{
   internal typealias FunctorCall = ((PixelData) -> PixelData)
   internal typealias FunctorIndexCall = ((Int,PixelData) -> PixelData)
}
