import Foundation
/**
 * Store module & screen scale
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
 * - Fixme: ⚠️️ rename to BufferSize? maybe not
 */
public struct Size {
   public let width: Int
   public let height: Int
   public init(_ width: Int, _ height: Int) {
      self.width = width
      self.height = height
   }
}
