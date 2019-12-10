import Foundation
/**
 * Setter
 */
extension PixelData {
   /**
    * setPixel (0-255) (⚠️️ not optimized ⚠️️)
    */
   mutating func setRGBA(r: UInt8, g: UInt8, b: UInt8, a: UInt8) {
      self.r = r
      self.g = g
      self.b = b
      self.a = a
   }
   /**
    * Fixme: ⚠️️ clean this up
    */
   mutating func setRGBA(first: PixelData, second: PixelData, alpha: UInt8) {
      _ = {
         let wrapAdd = first.r.addingReportingOverflow(second.r)
         self.r = wrapAdd.overflow ? 255 : wrapAdd.partialValue
      }()
      _ = {
         let wrapAdd = first.g.addingReportingOverflow(second.g)
         self.g = wrapAdd.overflow ? 255 : wrapAdd.partialValue
      }()
      _ = {
         let wrapAdd = first.b.addingReportingOverflow(second.b)
         self.b = wrapAdd.overflow ? 255 : wrapAdd.partialValue
      }()
//      if first.a < 255 {}
      self.a = alpha
   }
}
/**
 * Convenience
 */
extension PixelData {
   /**
    * Makes pixel black
    */
   mutating func setBlack() {
      self.setRGBA(r: 0, g: 0, b: 0, a: 255)
   }
   /**
    * Makes pixel white
    */
   mutating func setWhite() {
      self.setRGBA(r: 255, g: 255, b: 255, a: 255)
   }
   /**
    * Inverted (only works for pure black or pure white pixels)
    */
   func inverted() -> PixelData {
      return self.isWhite ? PixelData.blackPixel : PixelData.whitePixel
   }
}
/**
 * Experimental
 */
extension PixelData {
   /**
    * pixel.value -> R,G,B,A
    * setRGBA(argb: 4294967295)// 255, 255, 255, 255 aka UIColor.white
    */
   func setRGBA(argb: Int) -> RGBA {
      let r: UInt8 = .init((argb >> 16) & 0xFF)
      //      Swift.print("red:  \(red)")
      let g: UInt8 = .init((argb >> 8) & 0xFF)
      //      Swift.print("green:  \(green)")
      let b: UInt8 = .init(argb & 0xFF)
      //      Swift.print("blue:  \(blue)")
      let a: UInt8 = .init((argb >> 24) & 0xFF)
      //      Swift.print("a:  \(a)")
      return (r, g, b, a)
   }
}
/**
 * setRGBA (deprecated as it was not in use)
 */
//   mutating func setRGBA(color: Color) throws {
//      guard let rgba: RGBA = try? PixelDataUtil.rgba(uiColor: color) else { throw NSError.init(domain: "Unable to get rgba", code: 0) }//.rgba
//      setRGBA(r: rgba.r, g: rgba.g, b: rgba.b, a: rgba.a)
//   }
