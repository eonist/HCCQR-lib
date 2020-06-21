import Foundation

extension Pixel { enum Colors {} }
/**
 * Colors
 * - Fixme: ⚠️️ We are going to remove alpha, so rename to RGBColor again at some point
 */
extension Pixel.Colors {
   static let red: Pixel = .init(r: 255, g: 0, b: 0, a: 255)
   static let green: Pixel = .init(r: 0, g: 255, b: 0, a: 255)
   static let blue: Pixel = .init(r: 0, g: 0, b: 255, a: 255)
   // B&W
   static var black: Pixel { .init(r: .black, g: .black, b: UInt8.black, a: 255) }
   static var white: Pixel { .init(r: .white, g: .white, b: UInt8.white, a: 255) }
}
