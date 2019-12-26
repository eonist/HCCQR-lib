import Foundation

extension PixelData {
   enum Colors {
//      static let redPixel: PixelData = .init(r: 255, g: 0, b: 0, a: 255)
//      static let greenPixel: PixelData = .init(r: 0, g: 255, b: 0, a: 255)
//      static let bluePixel: PixelData = .init(r: 0, g: 0, b: 255, a: 255)
      static var blackPixel: PixelData { return .init(r: 0, g: 0, b: 0, a: 255) }
      static var whitePixel: PixelData { return .init(r: 255, g: 255, b: 255, a: 255) }
   }
}
