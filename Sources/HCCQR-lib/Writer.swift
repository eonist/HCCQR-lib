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
    * Data -> Image (Parrallel)
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
      let cgImg: CGImage = try cgImage(data: data, config: config, parallel: parallel)
      return ImageUtil.image(cgImage: cgImg, scale: CGFloat(config.scale.screen))
   }
   /**
    * Data -> CGImage
    */
   public static func cgImage(data: Data, config: HCCQRSetup, parallel: Bool) throws -> CGImage {
      let rep: RGBRep = try rgbRep(data: data, config: config, parallel: parallel)
      defer { rep.deallocate() }
      return try rep.cgImage()
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
   internal static func rgbRep(data: Data, config: HCCQRSetup, parallel: Bool) throws -> RGBRep {
      let dataArr: [Data] = /*autoreleasepool { */ HCCQRConfigUtil.data(data: data, config: config) /* }*/ // splits data (for multiple layers 2-8, 4-256 colors respectfully)
      let (ciImgs, qrTime): ([CIImage], Double) = TimeMeasure.timeElapsed {
         /*let ciImgs: [CIImage] = */dataArr.concurrentCompactMap(parallel: parallel) { (data: Data) in // parraelly create the qr-image-Layers
            try? QRWriter.ciImage(data: data, ecLevel: config.ecLevel) // Create B&W QR-layers (CIImage)
         }
      }
      Log.log("qrTime:  \(qrTime)")
      guard dataArr.count == ciImgs.count else { throw NSError(domain: "\(dataArr.count - ciImgs.count) qr imgs did not finish", code: 0) } // if qrImgs was not created correctly etc, we cant do try error inside concurrentMap
      let (rgbRep, colorizeTime): (RGBRep, Double) = try TimeMeasure.timeElapsed {
         /*let rgbaRep: RGBARep = */try Colorizer.colorize(qrLayers: ciImgs, config: config.output/*, coreCount: coreCount*/)
      }
      _ = colorizeTime
      Log.log("colorizeTime:  \(colorizeTime)")
      return rgbRep
   }
}
