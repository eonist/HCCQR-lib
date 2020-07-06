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
    * - Note: Splits an image into r,g,b channels
    * 1. RGBA-rep comes in
    * 2. RGBA-rep is split into many different color channels as Grayscale-Represenations
    * 3. Pass the color-channel-representations on to further processing
    * 4. Return QR-Image-Layers as result
    * - Fixme: ⚠️️  rename onComplete to onSplitComplete
    * - Note: Used in the process to convert HCCQR to Data
    * - Abstract: pair b&g = qr1(), pair r&b = qr2()
    * - Note: RGBAImage -> (3x GrayScaleRep) -> (2x QRImg)
    * - Note: the conversion to rgbaImg here is CPU intensive, but in the camera session we get RGBA data, so this is just for debugging etc
    * - Parameters:
    *   - rgbaRep: a HCCQR representation
    *   - pallete: the colors used in the HCCQR (4 to 256 colors)
    *   - onComplete: the callback when the split process is complete
    */
   static func split(rgbaRep: RGBARep, pallete: ChannelPallete, onComplete:@escaping SplitComplete) {
      // HCCQRReader.splitTime = .init() // Debugging performance
      Extractor.channels(rgbaImg: rgbaRep, pallete: pallete) { (result: GrayReps) in
         onExtractComplete(result: result, onComplete: onComplete)
      }
   }
}
