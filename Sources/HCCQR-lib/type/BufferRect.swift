import Foundation
import QuartzCore
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
