import Foundation
/**
 * RGB
 */
extension PixelData {
   static let red: PixelData = .init(r: 255, g: 0, b: 0/*, a: 255*/)
   static let green: PixelData = .init(r: 0, g: 255, b: 0/*, a: 255*/)
   static let blue: PixelData = .init(r: 0, g: 0, b: 255/*, a: 255*/)
}
/**
 * B&W colors
 * - Fixme: ⚠️️ We are going to remove alpha, so rename to RGBColor again at some point
 */
extension PixelData {
   static var black: PixelData { .init(r: .black, g: .black, b: .black/*, a: 255*/) }
   static var white: PixelData { .init(r: .white, g: .white, b: .white/*, a: 255*/) }
}
/**
 * Test colors
 */
extension PixelData {
   static let redish: PixelData = .init(r: UInt8(255 * 0.75), g: UInt8(255 * 0.2), b: UInt8(255 * 0.25)/*, a: 255*/)
   static let greenish: PixelData = .init(r: UInt8(255 * 0.27), g: UInt8(255 * 0.77), b: UInt8(255 * 0.25)/*, a: 255*/)
   static let blueish: PixelData = .init(r: UInt8(255 * 0.25), g: UInt8(255 * 0.25), b: UInt8(255 * 0.86)/*, a: 255*/)
   static let whiteish: PixelData = .init(r: UInt8(255 * 0.85), g: UInt8(255 * 0.95), b: UInt8(255 * 0.86)/*, a: 255*/)
   static let blackish: PixelData = .init(r: UInt8(255 * 0.15), g: UInt8(255 * 0.15), b: UInt8(255 * 0.16)/*, a: 255*/)
}
/**
 * CMY
 */
extension PixelData {
   static let cyan: PixelData = .init(r: 0, g: 255, b: 255/*, a: 255*/)
   static let magenta: PixelData = .init(r: 255, g: 0, b: 255/*, a: 255*/)
   static let yellow: PixelData = .init(r: 255, g: 255, b: 0/*, a: 255*/)
}
