import Foundation
/**
 * - Fixme: ⚠️️ Move colors to the Pixel-scope, it makes dot notation more readable, more succinct etc
 */
extension Pixel { enum Colors {} }
/**
 * RGB
 */
extension Pixel.Colors {
   static let red: Pixel = .init(r: 255, g: 0, b: 0, a: 255)
   static let green: Pixel = .init(r: 0, g: 255, b: 0, a: 255)
   static let blue: Pixel = .init(r: 0, g: 0, b: 255, a: 255)
}
/**
 * B&W colors
 * - Fixme: ⚠️️ We are going to remove alpha, so rename to RGBColor again at some point
 */
extension Pixel.Colors {
   static var black: Pixel { .init(r: .black, g: .black, b: UInt8.black, a: 255) }
   static var white: Pixel { .init(r: .white, g: .white, b: UInt8.white, a: 255) }
}
/**
 * Test colors
 */
extension Pixel.Colors {
   static let redish: Pixel = .init(r: UInt8(255 * 0.75), g: UInt8(255 * 0.2), b: UInt8(255 * 0.25), a: 255)
   static let greenish: Pixel = .init(r: UInt8(255 * 0.27), g: UInt8(255 * 0.77), b: UInt8(255 * 0.25), a: 255)
   static let blueish: Pixel = .init(r: UInt8(255 * 0.25), g: UInt8(255 * 0.25), b: UInt8(255 * 0.86), a: 255)
   static let whiteish: Pixel = .init(r: UInt8(255 * 0.85), g: UInt8(255 * 0.95), b: UInt8(255 * 0.86), a: 255)
   static let blackish: Pixel = .init(r: UInt8(255 * 0.15), g: UInt8(255 * 0.15), b: UInt8(255 * 0.16), a: 255)
}
/**
 * CMY
 */
extension Pixel.Colors {
   static let cyan: Pixel = .init(r: 0, g: 255, b: 255, a: 255)
   static let magenta: Pixel = .init(r: 255, g: 0, b: 255, a: 255)
   static let yellow: Pixel = .init(r: 255, g: 255, b: 0, a: 255)
}
