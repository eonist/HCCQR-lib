import Foundation

extension Pixel {
   /**
    * Beta
    */
   init(uiColor: Color) throws {
      let rgba: Pixel = try PixelParser.rgba(uiColor: uiColor)
      self.init(r: rgba.r, g: rgba.g, b: rgba.b, a: rgba.a)
   }
   /**
    * None param based init
    */
   init(_ r: UInt8, _ g: UInt8, _ b: UInt8, _ a: UInt8) {
      self.r = r
      self.g = g
      self.b = b
      self.a = a
   }
}
