import Foundation
import QuartzCore
/**
 * Getter
 */
extension RGBARep {
   /**
    * Convenience
    */
   var size: Size { .init(width, height) }
   var cgSize: CGSize { .init(width: CGFloat(self.width), height: CGFloat(self.height)) }
   var capacity: Int { self.width * self.height }
   /**
    * unsafePixels, new (⚠️️ might work, might not ⚠️️)
    * - Fixme: ⚠️️ rename to data
    */
   var flatPixels: UnsafePointer<UInt8> {
      let data = NSData(bytes: flatPixelArr, length: flatPixelArr.count)
//      Swift.print("revert to old solution ⚠️️ because swift 5.3 complain about dangling pointer 🤷 ")
      return data.bytes.assumingMemoryBound(to: UInt8.self)
      //      let pointer: UnsafePointer< UInt8 > = UnsafePointer(arr)
      //      return pointer
      //      return UnsafePointer(arr)
   }
   /**
    * There is also: let data: Data = .init(buffer: rgbaRep.pixels)
    */
   var data: Data {
      .init(bytes: flatPixelArr, count: flatPixelArr.count)
   }
   private var flatPixelArr: [UInt8] {
      pixels.flatMap { [$0.r, $0.g, $0.b, $0.a] }
   }
}
