import Foundation
import CoreImage
/**
 * RGBA-rep 👉 extract R,G,B 👉 combine colors 👉 QRImage's
 * - Note: you can derive the data by analysing each QRImage and combining their data to one data
 * - Fixme: ⚠️️ Rename to Combiner? or ReCombiner?
 */
public final class Splitter {}
/**
 * ⚠️️ New ⚠️️
 */
extension Splitter {
   /**
    * Splits HCCQR rep into qr layers
    * 1. Extracts graychannels for each color in channelPallet
    * 2. Orders these graychannels in special arrangments (defined by predefned rule-set)
    * 3. Converts to combinations of graychannels CIImage
    */
   internal static func split(rgbaRep: RGBARep, pallete: ChannelPallete) -> [CIImage] {
      let grayReps: GrayReps = Extractor.extract(rgbaRep: rgbaRep, pallete: pallete)
      let channelCombos: ChannelCombos = .combos(channels: grayReps) // arrays of grayreps (2 arrays of 2 grayReps for 4color hcqr, 3 arrays of 7 grayreps for 8 color-hccqr etc)
      return channelCombos.compactMap { Combiner.combine(grayReps: $0) } // combine
   }
}
