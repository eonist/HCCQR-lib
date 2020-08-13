import Foundation
import QuartzCore
/**
 * We add constants to Pixel to get dot notation, but also differentiate the name, to not overcrowd Pixel type
 */
typealias PixelColor = Pixel

extension PixelColor {
   // B&W colors
   static let black: Pixel = .init(r: .black, g: .black, b: .black)
   static let white: Pixel = .init(r: .white, g: .white, b: .white)
   // RGB
   static let red: Pixel = .init(r: 255, g: 0, b: 0)
   static let green: Pixel = .init(r: 0, g: 255, b: 0)
   static let blue: Pixel = .init(r: 0, g: 0, b: 255)
   // Test colors
   static let redish: Pixel = .init(r: UInt8(255 * 0.75), g: UInt8(255 * 0.2), b: UInt8(255 * 0.25))
   static let greenish: Pixel = .init(r: UInt8(255 * 0.27), g: UInt8(255 * 0.77), b: UInt8(255 * 0.25))
   static let blueish: Pixel = .init(r: UInt8(255 * 0.25), g: UInt8(255 * 0.25), b: UInt8(255 * 0.86))
   static let whiteish: Pixel = .init(r: UInt8(255 * 0.85), g: UInt8(255 * 0.95), b: UInt8(255 * 0.86))
   static let blackish: Pixel = .init(r: UInt8(255 * 0.15), g: UInt8(255 * 0.15), b: UInt8(255 * 0.16))
   // CMY
   static let cyan: Pixel = .init(r: 0, g: 255, b: 255)
   static let magenta: Pixel = .init(r: 255, g: 0, b: 255)
   static let yellow: Pixel = .init(r: 255, g: 255, b: 0)
}
/**
 * Getter
 */
extension PixelColor {
   /**
    * PixelColor -> Color
    * - Note: use of UInt8 speccific divide method, didn't make usable results
    * - Note: used by a few visual tests etc (no need to optimize)
    * - Fixme: ⚠️️ maybe move to PixelParser? To keep this class simple 👈
    */
   internal var color: Color {
      let r = CGFloat(self.r) / 255.0
      let g = CGFloat(self.g) / 255.0
      let b = CGFloat(self.b) / 255.0
      return .init(red: r, green: g, blue: b, alpha: 1)
   }
}
