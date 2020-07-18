import Foundation
import AVFoundation
import QuartzCore
import CoreImage
/**
 * - Note: We can't use CGRect, as we need Int values
 * - Fixme: ⚠️️ Possibly use UInt32, UInt64 etc in the future
 * - Fixme: ⚠️️ rename to Rect or no?
 */
public struct BufferRect {
   public let x: Int
   public let y: Int
   public let width: Int
   public let height: Int
   public init(_ x: Int, _ y: Int, _ width: Int, _ height: Int) {
      self.x = x
      self.y = y
      self.width = width
      self.height = height
   }
}
/**
 * - Fixme: ⚠️️ make extensions etc
 */
extension BufferRect {
   /**
    * BufferRect to CGRect
    */
   public var cgRect: CGRect {
      .init(x: self.x, y: self.y, width: self.width, height: self.height)
   }
}
/**
 * Returns the Rect of the Buffer, so that it can work with the cropping functionality
 * - Note: ⚠️️ this method is global, so that other class scopes can also use this functionality (Similar to how other Native Buffer methods work)
 * - Fixme: ⚠️️ rename to cvImage.. or maybe not sinc eits a global method
 * - Fixme: ⚠️️ we could actually scope this to the BufferRect now
 * - Parameter imageBuffer: the buffer containing the raw pixel data and size
 */
func CVImageBufferGetDisplayRect(imageBuffer: CVImageBuffer) -> BufferRect {
   let size: CGSize = CVImageBufferGetDisplaySize(imageBuffer)
   let point: CGPoint = .zero
   return .init(Int(point.x), Int(point.y), Int(size.width), Int(size.height))
}
