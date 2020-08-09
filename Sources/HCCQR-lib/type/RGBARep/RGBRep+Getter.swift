import Foundation
import QuartzCore
/**
 * Getter
 */
extension RGBRep {
   /**
    * Int size
    */
   var size: Size { .init(width, height) }
   /**
    * CGFloat size
    */
   var cgSize: CGSize { .init(width: CGFloat(self.width), height: CGFloat(self.height)) }
   /**
    * Num of pixels
    */
   var capacity: Int { self.width * self.height }
   /**
    * unsafePixels, new (⚠️️ might work, might not ⚠️️)
    * - Fixme: ⚠️️ rename to data?
    * - Fixme: ⚠️️ find cleaner way to convert between unsafe types etc
    * - Fixme: ⚠️️ make this optional
    * - Note: This method is now super fast
    */
   var flatPixels: UnsafePointer<UInt8> {
      let bytesPerPixel: Int = MemoryLayout<Pixel>.size
      let cap = capacity * bytesPerPixel
      let pointer = UnsafeMutableBufferPointer<UInt8>.allocate(capacity: cap)
      (0..<(capacity)).forEach { i in
         let p: Pixel = pixels[i]
         let idx = i * bytesPerPixel
         pointer[idx] = p.r
         pointer[idx + 1] = p.g
         pointer[idx + 2] = p.b
      }
      guard let p: UnsafeMutablePointer<UInt8> = pointer.baseAddress else { fatalError("err") }
      return .init(p)
   }
   /**
    * There is also: let data: Data = .init(buffer: rgbaRep.pixels)
    */
//   var data: Data {
//      let arr = flatPixelArr
//      return .init(bytes: arr, count: arr.count)
//   }
//   private var flatPixelArr: [UInt8] {
//      // - Fixme: ⚠️️ remove 255 in the future
//      let result: [[UInt8]] = (0..<capacity).map {
//         let p: Pixel = pixels[$0]
//         return [p.r, p.g, p.b, 255]
//      }
//      return result.flatMap { $0 }
//   }
}
