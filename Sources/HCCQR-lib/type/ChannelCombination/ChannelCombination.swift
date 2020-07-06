import Foundation

typealias ChannelCombination = [GrayRep]
typealias ChannelCombinations = [ChannelCombination]
/**
 * - Fixme: ⚠️️ rename to ChannelCombos etc, because its shorter etc
 */
extension ChannelCombinations {
   /**
    * Returns the the channel combinations for each layer
    * - Returns: For 4 Colored HCCQR, 2 channelCombo's are returned (8 = 3, 16, 4...etc)
    * - Parameters:
    *   - channels: there will be 4 channels for 4-color HCCQR (4-256)
    *   - layerCount: num of QRImage layers in the HCCQR
    */
   static func combinations(channels: [GrayRep]) -> ChannelCombinations {
      let layerCount: Int = BoolColumn.numOfLayers(numOfColors: channels.count)
      let layerIndicies: [Int] = (0..<layerCount).indices.map { $0 }
      let numOfColors: Int = channels.count // Int(pow(Double(layerCount), Double(layerCount))) // 2 = 4, 3 = 8, 4 = 16..etc
      let boolColumn: BoolColumn = BoolColumn.sequence(numOfColors)
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
extension ChannelCombinations {
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
