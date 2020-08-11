import Foundation
import QuartzCore
/**
 * - Note: We can't use CGRect, as we need Int values
 * - Fixme: ⚠️️ Possibly use UInt32, UInt64 etc in the future?
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
 * Getters
 */
extension BufferRect {
   /**
    * BufferRect to CGRect
    * - Note: Used by some of the buffer methods
    */
   public var cgRect: CGRect {
      .init(x: self.x, y: self.y, width: self.width, height: self.height)
   }
   /**
    * Size
    */
   public var size: BufferSize {
      .init(width, height)
   }
}
