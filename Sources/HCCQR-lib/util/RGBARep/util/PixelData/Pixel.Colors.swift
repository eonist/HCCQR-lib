import Foundation

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
 * CMY
 */
extension Pixel.Colors {
   static let cyan: Pixel = .init(r: 0, g: 255, b: 255, a: 255)
   static let magenta: Pixel = .init(r: 255, g: 0, b: 255, a: 255)
   static let yellow: Pixel = .init(r: 255, g: 255, b: 0, a: 255)
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
   static let redish: Pixel = .init(UInt8(255 * 0.75), UInt8(255 * 0.2), UInt8(255 * 0.25), 255)
   static let greenish: Pixel = .init(UInt8(255 * 0.27), UInt8(255 * 0.77), UInt8(255 * 0.25), 255)
   static let blueish: Pixel = .init(UInt8(255 * 0.25), UInt8(255 * 0.25), UInt8(255 * 0.86), 255)
   static let whiteish: Pixel = .init(UInt8(255 * 0.85), UInt8(255 * 0.95), UInt8(255 * 0.86), 255)
   static let blackish: Pixel = .init(UInt8(255 * 0.15), UInt8(255 * 0.15), UInt8(255 * 0.16), 255)
}
