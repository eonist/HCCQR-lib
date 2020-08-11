import Foundation
/**
 * Array of ChannelCombo
 */
typealias ChannelCombos = [GrayReps]
/**
 * Helper methods for ChannelCombos
 */
extension ChannelCombos {
   /**
    * Returns the the channel combinations for each layer
    * - Description: Basically the different color channels that make up a layer, for 4-color HCCQR that is 2 layers, for 8 colors its 3+ etc
    * - Note: the output ignores all true values, i.e posetivr (aka white etc)
    * - Note: The output will look something like this for: [.white, .red, .green, .blue]) // [[.blue,.red], [.red, .green]]
    * - Note: No need to improve performance on this alot, it's not expensive to call
    * - Returns: For 4 Colored HCCQR, 2 channelCombo's are returned (8 = 3, 16, 4...etc)
    * - Parameters:
    *   - channels: there will be 4 channels for 4-color HCCQR (4-256)
    *   - layerCount: num of QRImage layers in the HCCQR
    */
   static func combos(channels: GrayReps) -> ChannelCombos {
      let layerCount: Int = BoolColumn.numOfLayers(numOfColors: channels.count)
      let layerIndicies: [Int] = (0..<layerCount).map { $0 } // [0, 1] for 4-color-HCCQR ⚠️️ this uses compactmap, because lint gives a warning for regular map, and other alternatives doesn't work inside array extension
      let boolColumn: BoolColumn = .sequence(channels.count)
      let channelCombinations: [[Int]] = layerIndicies.map { rowIndices(col: boolColumn, layerIdx: $0) }
      return channelCombinations.map { (channelCombination: [Int]) in
         channelCombination.map { (channelIndex: Int) in
            channels[channelIndex]
         }
      }
   }
}
/**
 * Private static helper
 */
extension ChannelCombos {
   /**
    * Return index of false in the row in the column
    * - Note: Used when re-combining colors into QRLayers
    * - Fixme: ⚠️️ This could potentially be stored values, since it's the same every time, but it doesnt take any time to process etc, so not a pri atm
    * ## Examples:
    * rowIdx(col: [[1,1],[0,1],[1,0],[0,0]], 0) // [1, 3]
    * - Parameters:
    *   - col: column that contains rows
    *   - layerIdx: QRImage layer index
    */
   private static func rowIndices(col: BoolColumn, layerIdx: Int) -> [Int] {
      col.enumerated().compactMap { !$0.element[layerIdx] ? $0.offset : nil }
   }
}
