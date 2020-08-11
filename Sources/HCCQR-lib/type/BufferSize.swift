import Foundation
import QuartzCore
@available(*, deprecated, renamed: "BufferSize")
typealias Size = BufferSize

public struct BufferSize {
   public let width: Int
   public let height: Int
   public init(_ width: Int, _ height: Int) {
      self.width = width
      self.height = height
   }
}
/**
 * Getters
 */
extension BufferSize {
   /**
    * Size to CGRect
    */
   internal var cgRect: CGRect {
      .init(x: 0, y: 0, width: self.width, height: self.height)
   }
   internal var cgSize: CGSize {
      .init(width: self.width, height: self.height)
   }
   internal var capacity: Int { self.width * self.height }
}
