import Foundation
/**
 * We add constants to Pixel to get dot notation, but also differentiate the name, to not overcrowd Pixel type
 */
typealias PixelColor = Pixel
/**
 * RGB
 */
extension PixelColor {
   static let red: Pixel = .init(r: 255, g: 0, b: 0)
   static let green: Pixel = .init(r: 0, g: 255, b: 0)
   static let blue: Pixel = .init(r: 0, g: 0, b: 255)
}
/**
 * B&W colors
 */
extension PixelColor {
   static var black: Pixel { .init(r: .black, g: .black, b: .black) }
   static var white: Pixel { .init(r: .white, g: .white, b: .white) }
}
/**
 * Test colors
 */
extension PixelColor {
   static let redish: Pixel = .init(r: UInt8(255 * 0.75), g: UInt8(255 * 0.2), b: UInt8(255 * 0.25))
   static let greenish: Pixel = .init(r: UInt8(255 * 0.27), g: UInt8(255 * 0.77), b: UInt8(255 * 0.25))
   static let blueish: Pixel = .init(r: UInt8(255 * 0.25), g: UInt8(255 * 0.25), b: UInt8(255 * 0.86))
   static let whiteish: Pixel = .init(r: UInt8(255 * 0.85), g: UInt8(255 * 0.95), b: UInt8(255 * 0.86))
   static let blackish: Pixel = .init(r: UInt8(255 * 0.15), g: UInt8(255 * 0.15), b: UInt8(255 * 0.16))
}
/**
 * CMY
 */
extension PixelColor {
   static let cyan: Pixel = .init(r: 0, g: 255, b: 255)
   static let magenta: Pixel = .init(r: 255, g: 0, b: 255)
   static let yellow: Pixel = .init(r: 255, g: 255, b: 0)
}
