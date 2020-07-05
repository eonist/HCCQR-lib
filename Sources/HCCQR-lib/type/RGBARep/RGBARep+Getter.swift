import Foundation
import QuartzCore
/**
 * Getter
 */
extension RGBARep {
   /**
    * Convenience
    */
   var size: Size { (width: width, height: height) }
   var cgSize: CGSize { .init(width: CGFloat(self.width), height: CGFloat(self.height)) }
   var capacity: Int { self.width * self.height }
   /**
    * unsafePixels, new (⚠️️ might work, might not ⚠️️)
    */
   var flatPixels: UnsafePointer<UInt8> {
      let arr: [UInt8] = pixels.flatMap { [$0.r, $0.g, $0.b, $0.a] }
      let data = NSData(bytes: arr, length: arr.count)
//      Swift.print("revert to old solution ⚠️️ because swift 5.3 complain about dangling pointer 🤷 ")
      return data.bytes.assumingMemoryBound(to: UInt8.self)
      //      let pointer: UnsafePointer< UInt8 > = UnsafePointer(arr)
      //      return pointer
      //      return UnsafePointer(arr)
   }
}
