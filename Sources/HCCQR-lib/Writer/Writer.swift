import Foundation
import QR_lib
import CoreImage
/**
 * Creates HCCQR-Image from binary Data
 */
public final class Writer {}

extension Writer {
   /**
    * Data 👉 RGBAImage 👉 Image (Parrallel)
    * 1. Data comes in with config and scale
    * 2. Converts data to RGBARep
    * 3. Converts RGBARep to Image
    * - Fixme: ⚠️️ Could setting CIImage or CGIMage directly to a Image in the UI be faster?
    * - Fixme: ⚠️️ create custom error cases
    * - Parameters:
    *   - data: data to be converted to HCCQR
    *   - config: config of HCCQR
    */
   public static func img(data: Data, config: HCCQRSetup) throws -> Image {
      let rep: RGBARep = try rgbaRep(data: data, config: config)
      let image: Image = try RGBARepParser.image(rgbaRep: rep, scale: CGFloat(config.scale.screen))
      return image
   }
}
/**
 * Internal static helper
 */
extension Writer {
   /**
    * Data 👉 [CIImage's] 👉 RGBARep
    * 1. Data comes in with config and scale
    * 2. Splits the data into two
    * 3. Creates multiple CIImage's of these multiple data items
    * - Abstract: Create two QR images from the data, and combine them into RGBAImage, then convert that to CIImage
    * - Caution: ⚠️️ Remember to deinit the result once it's consumed
    * - Important: internal because: SingleWriteReadHCCQRTest and BulkHCCQRTest uses it for tests
    * - Fixme: ⚠️️ Splitting the data in two allows 4 color map, in the future we will allow 8 color map etc (pallet etc)
    * - Fixme: ⚠️️ remove default value?
    */
   internal static func rgbaRep(data: Data, config: HCCQRSetup = .default) throws -> RGBARep {
      let dataArr: [Data] = HCCQRConfigUtil.data(data: data, config: config) // splits data
      let ciImgs: [CIImage] = dataArr.concurrentCompactMap { (data: Data) in // parraelly create the qr-image-Layers
         try? QRWriter.ciImage(data: data, ecLevel: config.ecLevel) // Create B&W QR-layers (CIImage)
      }
      guard dataArr.count == ciImgs.count else { throw NSError("\(dataArr.count - ciImgs.count) qr imgs did not finish") } // if qrImgs was not created correctly etc
      // - Fixme: ⚠️️ benchmark how timeconsuming the colorization part is, if its worth doing parallel processing on
      let rgbaRep: RGBARep = Colorizer.colorize(qrLayers: ciImgs, config: config.output/*, coreCount: coreCount*/)
      return rgbaRep
   }
}
