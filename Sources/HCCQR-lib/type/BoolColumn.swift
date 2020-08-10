import Foundation
/**
 * Stores the order of the stacked b&w layers
 * - Description: The boolean pattern that unlocks each color
 * - Note: store the rgb colors as an array, (similar to color channels)
 */
typealias BoolColumn = [BoolRow]
/**
 * Stores the bool array for each b&w layer
 * - Note: used in colormap as well
 */
public typealias BoolRow = [Bool]
/**
 * Extensions
 */
extension BoolColumn {
   /**
    * Creates a bool column for num of colors in HCCQR
    * ## Examples:
    * .sequence(4) // [[1,1],[0,1],[1,0],[0,0]]
    * .sequence(8) // [[1,1,1],[0,1,1],[1,0,1],[1,1,0],[0,0,1],[0,1,0],[1,0,0],[0,0,0]]
    * - Parameter numOfColors: number of colors in the HCCQR
    */
   static func sequence(_ numOfColors: Int) -> BoolColumn {
      let numberOfLayers = numOfLayers(numOfColors: numOfColors)
      return BinarySequencer.sequence(size: numberOfLayers)
   }
   /**
    * Returns "num of layers" for "num of colors"
    */
   static func numOfLayers(numOfColors: Int) -> Int {
      Algebra.exponent(base: 2, value: numOfColors)
   }
}
