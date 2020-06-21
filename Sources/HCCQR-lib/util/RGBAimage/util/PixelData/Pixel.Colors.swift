import Foundation

extension Pixel {
   enum Colors {}
}
/**
 * Colors
 */
extension Pixel.Colors {
   static let redPixel: Pixel = .init(r: 255, g: 0, b: 0, a: 255)
   static let greenPixel: Pixel = .init(r: 0, g: 255, b: 0, a: 255)
   static let bluePixel: Pixel = .init(r: 0, g: 0, b: 255, a: 255)
   // B&W
   static var blackPixel: Pixel { .init(r: .black, g: .black, b: UInt8.black, a: 255) }
   static var whitePixel: Pixel { .init(r: .white, g: .white, b: UInt8.white, a: 255) }
}
