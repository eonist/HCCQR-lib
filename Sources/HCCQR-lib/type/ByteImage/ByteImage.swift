import Foundation
import CoreImage

public struct ByteImage {
   public var pixels: UnsafeMutableBufferPointer<BytePixel>
   public var width: Int
   public var height: Int
}
// 🏀
// make RGBARepKind
// move to protocol API
