import Foundation
import CoreImage
/**
 * ByteImage
 */
public struct ByteImage: ImageRepKind {
   var pixels: UnsafeBufferPointer<PixelData>
   var width: Int
   var height: Int
}
