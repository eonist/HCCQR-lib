import Foundation
/**
 * Stores the order of the stacked b&w layers
 * - Abstract: The boolean pattern that unlocks each color
 */
typealias BoolColumn = [BoolRow]
/**
 * Stores the bool array for each b&w layer
 */
public typealias BoolRow = [Bool]
/**
 * - Note: store the bool array as a const.
 * - Note: uses zip or similar to weave in the data into the color map
 * - Note: store the rgb colors as an array, (same as color channels)
 */
extension BoolColumn {
   /**
    * 4-color-scheme
    * - Fixme: ⚠️️ rename to fourBoolCol
    */
   static let fourColorScheme: BoolColumn = [
      [false, true],
      [true, false],
      [true, true],
      [false, false]
   ]
   /**
    * 8-color-scheme
    * - Fixme: ⚠️️ the order of these may not be important? other than frequency of use?
    */
   static let eightColorScheme: BoolColumn = [
      /*2 true*/
      [false, true, true],
      [true, true, false],
      [true, false, true],
      /*2 false*/
      [true, false, false],
      [false, false, true],
      [false, true, false],
      /*3 false*/
      [true, true, true],
      /*3 true*/
      [false, false, false]
   ]
}
