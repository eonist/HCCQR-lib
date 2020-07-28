import Foundation
import QR_lib
import CoreImage
import ParallelLoop
import TimeMeasure
/**
 * Creates HCCQR-Image from binary Data
 */
public typealias HCCQRWriter = Writer
public final class Writer {}

extension Writer {
   /**
    * Data -> RGBAImage -> Image (Parrallel)
    * 1. Data comes in with config and scale
    * 2. Converts data to RGBARep
    * 3. Converts RGBARep to Image
    * - Fixme: ⚠️️ Could setting CIImage or CGIMage directly to a Image in the UI be faster?
    * - Fixme: ⚠️️ create custom error cases
    * - Parameters:
    *   - data: data to be converted to HCCQR
    *   - config: config of HCCQR
    *   - parallel: for single capture, parallel is fast, for sequence, parallel is slower
    */
   public static func image(data: Data, config: HCCQRSetup, parallel: Bool) throws -> Image {
      let rep: RGBARep = try rgbaRep(data: data, config: config, parallel: parallel)
      defer { rep.deallocate() }
      return try RGBARepParser.image(rgbaRep: rep, scale: CGFloat(config.scale.screen))
   }
}
/**
 * Internal static helper
 */
extension Writer {
   /**
    * Data -> [CIImage's] -> RGBARep
    * 1. Data comes in with config and scale
    * 2. Splits the data into two
    * 3. Creates multiple CIImage's of these multiple data items
    * - Abstract: Create two QR images from the data, and combine them into RGBAImage, then convert that to CIImage
    * - Important: ⚠️️ Remember to deInit the result once it's consumed
    * - Important: ⚠️️ internal because: SingleWriteReadHCCQRTest and BulkHCCQRTest uses it for tests
    * - Parameters:
    *   - data: data to be converted to HCCQR
    *   - config: config of HCCQR
    *   - parallel: for single capture, parallel is fast, for sequence, parallel is slower
    */
   internal static func rgbaRep(data: Data, config: HCCQRSetup, parallel: Bool) throws -> RGBARep {
      let dataArr: [Data] = HCCQRConfigUtil.data(data: data, config: config) // splits data (for multiple layers 2-8, 4-256 colors respectfully)
      let ciImgs: [CIImage] = dataArr.concurrentCompactMap(parallel: parallel) { (data: Data) in // parraelly create the qr-image-Layers
         try? QRWriter.ciImage(data: data, ecLevel: config.ecLevel) // Create B&W QR-layers (CIImage)
      }
      guard dataArr.count == ciImgs.count else { throw NSError(domain: "\(dataArr.count - ciImgs.count) qr imgs did not finish", code: 0) } // if qrImgs was not created correctly etc, we cant do try error inside concurrentMap
      let (rgbaRep, colorizeTime): (RGBARep, Double) = try TimeMeasure.timeElapsed {
         /*let rgbaRep: RGBARep = */try Colorizer.colorize(qrLayers: ciImgs, config: config.output/*, coreCount: coreCount*/)
      }
      _ = colorizeTime
      Log.log("colorizeTime:  \(colorizeTime)")
      return rgbaRep
   }
}
