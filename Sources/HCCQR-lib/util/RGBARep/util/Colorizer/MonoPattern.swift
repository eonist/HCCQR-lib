import Foundation
/**
 * Stores the order of the stacked b&w layers
 * - Abstract: The boolean pattern that unlocks each color
 * - Fixme: ⚠️️  find better name: turnKey, combination, sequence, BoolSequence?
 */
typealias MonoPattern = [MonoPatternItem]
typealias MonoPatternItem = [Bool]

/**
 * - Note: store the bool array as a const.
 * - Note: uses zip or similar to weave in the data into the color map
 * - Note: store the rgb colors as an array, (same as color channels)
 */
extension MonoPattern {
   /**
    * 4-color-scheme
    */
   static let fourColorScheme: MonoPattern = [
      [false, true],
      [true, false],
      [true, true],
      [false, false]
   ]
   /**
    * 8-color-scheme
    * - Fixme: ⚠️️ the order of these may not be important? other than frequency of use?
    */
   static let eightColorScheme: MonoPattern = [
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
