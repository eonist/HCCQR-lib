import Foundation

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
      let numOfLayers: Int = Algebra.exponent(base: 2, value: numOfColors)
      return numOfLayers
   }
}
