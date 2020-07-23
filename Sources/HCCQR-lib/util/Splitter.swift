import Foundation
import CoreImage
import ParallelLoop
import TimeMeasure
/**
 * RGBA-rep 👉 extract R,G,B 👉 combine colors 👉 QRImage's
 * - Note: you can derive the data by analysing each QRImage and combining their data to one data
 */
public final class Splitter {}
/**
 * ⚠️️ New ⚠️️
 */
extension Splitter {
   /**
    * Splits HCCQR rep into b&w qr layers
    * 1. Extracts graychannels for each color in channelPallet
    * 2. Araneges these graychannels in special arrangments (defined by predefned HCCQR rule-set depending on num of colors used)
    * 3. Converts to combinations of graychannels CIImage
    * - Note: when added to an UIImage, you need to set scale to 2.0 and orientation to .up
    * - Note: Splits an image into r,g,b channels
    * - Note: the conversion to rgbaImg here is CPU intensive, but in the camera session we get RGBA data, so this is just for debugging etc
    * - Note: extracting is cpu consuming, creating combos is not, combining is a bit cpu consuming
    * - Parameters:
    *   - rgbaRep: a HCCQR representation
    *   - scheme: the colors used in the HCCQR (4 to 256 colors)
    */
   internal static func split(rgbaRep: RGBARep, scheme: ChannelScheme, parallel: Bool) -> [CIImage] {
      let (grayReps, extractTime): (GrayReps, Double) = TimeMeasure.timeElapsed {
         /*let grayReps: GrayReps = */Extractor.extract(rgbaRep: rgbaRep, scheme: scheme, parallel: parallel)
      }
      Swift.print("extractTime:  \(extractTime)")
      let (channelCombos, comboTime): (ChannelCombos, Double) = TimeMeasure.timeElapsed {
         /*let channelCombos: ChannelCombos = */.combos(channels: grayReps) // Arrays of grayreps (2 arrays of 2 grayReps for 4color hcqr, 3 arrays of 7 grayreps for 8 color-hccqr etc)
      }
      Swift.print("comboTime:  \(comboTime)")
      let (combinations, combineTime): ([CIImage], Double) = TimeMeasure.timeElapsed {
         channelCombos.concurrentCompactMap(parallel: parallel) { Combiner.combine(grayReps: $0) } // combine the combinations to produce layers of qr-images
      }
      grayReps.deInit()
      Swift.print("combineTime:  \(combineTime)")
      return combinations
   }
}
