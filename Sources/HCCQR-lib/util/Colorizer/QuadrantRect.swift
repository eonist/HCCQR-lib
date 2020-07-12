import Foundation
import QuartzCore

final class QuadrantRect {
   /**
    * Returns a slice of a rectangle depending on the index of that slice. Sliced to count
    * - Note: creates int based rect, in order to distribute heavy tasks over many cpu cores
    * - Returns: rect is int based CGRect
    * ## Examples:
    * let coreCount: Int = ProcessInfo().activeProcessorCount
    * quadrantRect(idx: 0, coreCount: coreCount, (200, 200)) //
    *
    */
   static func quadrantRect(idx: Int, count: Int, size: Size) -> BufferRect {
      let rowHeight: Int = .init(ceil(CGFloat(size.height / count)))
      let y: Int = rowHeight * idx
      let h: Int = {
         if idx == count - 1 { return min(y + rowHeight, size.height) - y } // don't go beyond max
         return rowHeight
      }()
      return (0, y, size.width, h) // x is always zero, because we just have 1 column
   }
}
