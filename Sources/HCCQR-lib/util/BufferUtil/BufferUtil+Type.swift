import Foundation
import AVFoundation
import QuartzCore
import CoreImage
/**
 * - Note: We can't use CGRect, as we need Int values
 * - Fixme: ⚠️️ Possibly use UInt32, UInt64 etc in the future
 * - Fixme: ⚠️️ make BufferRect a struct, better for extension etc
 */
public typealias BufferRect = (x: Int, y: Int, width: Int, height: Int)
/**
 * - Fixme: ⚠️️ make extensions etc
 */
public class BufferRectUtil {
   /**
    * BufferRect to CGRect
    */
   public static func cgRect(bufferRect: BufferRect) -> CGRect {
      .init(x: bufferRect.x, y: bufferRect.y, width: bufferRect.width, height: bufferRect.height)
   }
}
/**
 * Returns the Rect of the Buffer, so that it can work with the cropping functionality
 * - Note: ⚠️️ this method is global, so that other class scopes can also use this functionality (Similar to how other Native Buffer methods work)
 */
func CVImageBufferGetDisplayRect(imageBuffer: CVImageBuffer) -> BufferRect {
   let size: CGSize = CVImageBufferGetDisplaySize(imageBuffer)
   let point: CGPoint = .zero
   return (width: Int(size.width), height: Int(size.height), x: Int(point.x), y: Int(point.y))
}
