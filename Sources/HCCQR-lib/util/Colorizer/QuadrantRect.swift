import Foundation
import QuartzCore

final class QuadrantRect {
   /**
    * Returns a slice of a rectangle depending on the index of that slice. Sliced to count
    * - Note: creates int based rect, in order to distribute heavy tasks over many cpu cores
    * - Returns: rect is int based CGRect
    * ## Examples:
    * let coreCount: Int = ProcessInfo().activeProcessorCount
    * quadrantRect(idx: 0, coreCount: coreCount, (276, 276)) // 34
    * quadrantRect(idx: 7, coreCount: coreCount, (276, 276)) // 38 (left over)
    * - Fixme: ⚠️️ if size is not dividable by coreCount, then there will be issues, make fallback functionality
    */
   internal static func quadrantRect(idx: Int, count: Int, size: Size) -> BufferRect {
      let rowHeight: Int = .init(round(CGFloat(size.height) / CGFloat(count)))
//      Swift.print("rowHeight:  \(rowHeight)")
      let y: Int = rowHeight * idx
      let h: Int = {
         if idx == count - 1 { return size.height - y } // return the left-over
         return rowHeight
      }()
      return (0, y, size.width, h) // x is always zero, because we just have 1 column
   }
}
