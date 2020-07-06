import Foundation
/**
 * Helper methods for ChannelCombos
 */
extension ChannelCombos {
   /**
    * Returns the the channel combinations for each layer
    * - Note: the output ignores all true values, i.e posetivr (aka white etc)
    * - Note: The output will look something like this for: [.white,.red,.green,.blue]) // [[.blue,.red], [.red, .green]]
    * - Returns: For 4 Colored HCCQR, 2 channelCombo's are returned (8 = 3, 16, 4...etc)
    * - Parameters:
    *   - channels: there will be 4 channels for 4-color HCCQR (4-256)
    *   - layerCount: num of QRImage layers in the HCCQR
    */
   static func combos(channels: GrayReps) -> ChannelCombos {
      let layerCount: Int = BoolColumn.numOfLayers(numOfColors: channels.count)
      let layerIndicies: [Int] = (0..<layerCount).indices.compactMap { $0 } // ⚠️️ this uses compactmap, because lint gives a warning for regular map, and other alternatives doesnt work inside array extension
      let numOfColors: Int = channels.count // Int(pow(Double(layerCount), Double(layerCount))) // 2 = 4, 3 = 8, 4 = 16..etc
      let boolColumn: BoolColumn = .sequence(numOfColors)
      let channelCombinations: [[Int]] = layerIndicies.map { rowIdx(col: boolColumn, layerIdx: $0) }
      return channelCombinations.map { channelCombination in
         channelCombination.map { channelIndex in
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
    * - Fixme: ⚠️️ This could potentially be stored values, since it's the same every time
    * - Fixme: ⚠️️ rename to rowIndices?
    * ## Examples:
    * rowIdx(col: [[1,1],[0,1],[1,0],[0,0]], 0) // [1,3]
    * - Parameters:
    *   - col: column that contains rows
    *   - layerIdx: QRImage layer index
    */
   private static func rowIdx(col: BoolColumn, layerIdx: Int) -> [Int] {
      col.compactMap { !$0[layerIdx] ? layerIdx : nil }
   }
}
