import Foundation
import CoreImage
/**
 * ByteImage
 */
public struct ByteImage {
   public var pixels: UnsafeBufferPointer<BytePixel>
   public var width: Int
   public var height: Int
}
