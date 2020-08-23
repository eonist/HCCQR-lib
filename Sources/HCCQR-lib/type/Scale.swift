import Foundation
/**
 * Store module & screen scale
 * - Note: module-size can be the same for any QR-Version, it is only relevant for the final size of the QR rectangle
 */
public struct Scale {
   public let module: Int
   public let screen: Int
   /**
    * - Parameters:
    *   - module: 1-module means 1qr-unit is 1x1 Pixel, 8 means 8x8 Pixel
    *   - screen: 1px means normal screen 2x mens retina screen etc
    */
   public init(_ module: Int, _ screen: Int) {
      self.module = module
      self.screen = screen
   }
}
/**
 * Getter
 */
extension Scale {
   static let `default`: Scale = .init(6, 2)
}
