import Foundation

public struct BytePixel: PixelDataKind {
   public var value: UInt32
   /**
    * - Fixme: ⚠️️ needs more performant code maybe?
    */
   public init(r: UInt8, g: UInt8, b: UInt8/*, a: UInt8 = 255*/) {
//      let alpha: UInt32 = .init(255 & 0xFF)
      let red: UInt32 = .init(r & 0xFF)
      let green: UInt32 = .init(g & 0xFF)
      let blue: UInt32 = .init(b & 0xFF)
      let rgb: UInt32 = (blue << 16) + (green << 8) + red// + (alpha << 24)
      self.value = rgb
   }
}
/**
 * Getter
 */
extension BytePixel {
   /**
    * b
    */
   public var b: UInt8 {
      get { UInt8((value >> 16) & 0xFF) }
      set {
         let v = max(min(newValue, 255), 0)
         value = (UInt32(v) << 16) | (value & 0xFF00FFFF)
      }
   }
   /**
    * green
    */
   public var g: UInt8 {
      get { UInt8((value >> 8) & 0xFF) }
      set {
         let v = max(min(newValue, 255), 0)
         value = (UInt32(v) << 8) | (value & 0xFFFF00FF)
      }
   }
   /**
    * r
    */
   public var r: UInt8 {
      get { UInt8(value & 0xFF) }
      set {
         let v = max(min(newValue, 255), 0)
         value = UInt32(v) | (value & 0xFFFFFF00)
      }
   }
   /**
    * alpha
    */
//   public var a: UInt8 {
//      get { UInt8((value >> 24) & 0xFF) }
//      set {
//         let v = max(min(newValue, 255), 0)
//         value = (UInt32(v) << 24) | (value & 0x00FFFFFF)
//      }
//   }
}
/**
 * Floating values
 */
extension BytePixel {
   public var Rf: Double {
      get { Double(self.r) / 255.0 }
      set { self.r = UInt8(max(min(newValue, 1.0), 0.0) * 255.0) }
   }
   public var Gf: Double {
      get { Double(self.g) / 255.0 }
      set { self.g = UInt8(max(min(newValue, 1.0), 0.0) * 255.0) }
   }
   public var Bf: Double {
      get { Double(self.b) / 255.0 }
      set { self.b = UInt8(max(min(newValue, 1.0), 0.0) * 255.0) }
   }
//   public var Af: Double {
//      get { Double(self.a) / 255.0 }
//      set { self.a = UInt8(max(min(newValue, 1.0), 0.0) * 255.0) }
//   }
}
