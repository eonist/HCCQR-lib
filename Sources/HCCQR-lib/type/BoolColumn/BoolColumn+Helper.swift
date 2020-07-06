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
      let numOfLayers: Int = Algebra.exponent(base: 2, value: numOfColors)
      return BinarySequencer.sequence(size: numOfLayers)
   }
   /**
    * Return index of false in the row in the column
    * - Note: Used when re-combining colors into QRLayers
    * - Fixme: ⚠️️ This could potentially be stored values, since it's the same every time
    * ## Examples:
    * rowIdx(col: [[1,1],[0,1],[1,0],[0,0]], 0) // [1,3]
    */
   static func rowIdx(col: BoolColumn, layerIdx: Int) -> [Int] {
      col.compactMap { !$0[layerIdx] ? layerIdx : nil }
   }
}
