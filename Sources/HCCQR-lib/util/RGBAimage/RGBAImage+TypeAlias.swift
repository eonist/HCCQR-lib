import Foundation

extension RGBAImage {
   internal typealias FunctorCall = ((PixelData) -> PixelData)
   internal typealias FunctorIndexCall = ((Int, PixelData) -> PixelData)
   internal typealias Size = (width: Int, height: Int)
}
