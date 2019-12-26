import Foundation
/**
 * RGBColor
 */
extension PixelData {
   typealias RGBColor = (r: UInt8, g: UInt8, b: UInt8, a: UInt8)
   static let red: RGBColor = (r: 255, g: 0, b: 0, a: 255)
   static let green: RGBColor = (r: 0, g: 255, b: 0, a: 255)
   static let blue: RGBColor = (r: 0, g: 0, b: 255, a: 255)
   static let white: RGBColor = (r: 255, g: 255, b: 255, a: 255)
}
