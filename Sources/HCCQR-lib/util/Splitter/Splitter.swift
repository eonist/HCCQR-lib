import Foundation
import CoreImage
/**
 * RGBA-rep 👉 extract R,G,B 👉 combine colors 👉 QRImage's
 * - Note: you can derive the data by analysing each QRImage and combining their data to one data
 * - Fixme: ⚠️️ Rename to Combiner? or ReCombiner?
 */
public final class Splitter {}

extension Splitter {
   /**
    * Returns two b&w qr images in RGBAImage format (by splitting a single hccqr ciImage)
    * 1. RGBA-rep comes in
    * 2. RGBA-rep is split into many different color channels as Grayscale-Represenations
    * 3. Pass the color-channel-representations on to further processing
    * 4. Return QR-Image-Layers as result
    * - Note: Used in the process to convert HCCQR to Data
    * - Abstract: pair b&g = qr1(), pair r&b = qr2()
    * - Note: RGBAImage -> (3x GrayScaleRep) -> (2x QRImg)
    * - Note: the conversion to rgbaImg here is CPU intensive, but in the camera session we get RGBA data, so this is just for debugging etc
    * - Fixme: ⚠️️ potentially remove the default vaclue for channel map
    */
   static func split(rgbaRep: RGBARep, pallete: ChannelPallete = .fourChannels, onComplete:@escaping SplitComplete) {
      // HCCQRReader.splitTime = .init() // Debugging performance
      Extractor.channels(rgbaImg: rgbaRep, pallete: pallete) { (result: Extractor.ChannelResult) in
         onSplitComplete(result: result, onComplete: onComplete)
      }
   }
}
