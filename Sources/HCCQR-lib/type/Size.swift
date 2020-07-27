import Foundation
import QuartzCore
/**
 * - Fixme: ⚠️️ rename to BufferSize? maybe not
 */
public struct Size {
   public let width: Int
   public let height: Int
   public init(_ width: Int, _ height: Int) {
      self.width = width
      self.height = height
   }
}
/**
 * - Fixme: ⚠️️ make extensions etc
 */
extension Size {
   /**
    * Size to CGRect
    */
   internal var cgRect: CGRect {
      .init(x: 0, y: 0, width: self.width, height: self.height)
   }
   internal var capacity: Int { self.width * self.height }
}
