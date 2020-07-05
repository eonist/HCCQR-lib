import Foundation
/**
 * Stores the order of the stacked b&w layers
 * - Abstract: The boolean pattern that unlocks each color
 * - Note: store the rgb colors as an array, (similar to color channels)
 */
typealias BoolColumn = [BoolRow]

extension BoolColumn {
   /**
    * Creates a bool column for num of colors in HCCQR
    * ## Examples:
    * .sequence(4) // [[1,1],[0,1],[1,0],[0,0]]
    * - Parameter numOfColors: number of colors in the HCCQR
    */
   static func sequence(_ numOfColors: Int) -> BoolColumn {
      let numOfLayers: Int = Algebra.exponent(base: 2, value: numOfColors)
      return BinarySequencer.sequence(size: numOfLayers)
   }
}
