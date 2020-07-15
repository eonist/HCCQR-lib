import Foundation
import QR_lib
import CoreImage
/**
 * Creates HCCQR-Image from binary Data
 */
public final class Writer {}
/**
 * Quadrant optimization test (⚠️️ new ⚠️️)
 */
extension Writer {
   /**
    * - Fixme: ⚠️️ throw in the future
    * - Fixme: ⚠️️ create custom error cases
    * - Parameters:
    *   - data: data to be converted to HCCQR
    *   - config: config of HCCQR
    */
   public static func img(data: Data, config: HCCQRSetup) -> Image? {
      guard let rep: RGBARep = rgbaRep(data: data, config: config) else { return nil }
      guard let image: Image = try? RGBARepParser.image(rgbaRep: rep, scale: CGFloat(config.scale.screen)) else { return nil }
      return image
   }
   /**
    * ⚠️️ New ⚠️️
    * - Fixme: ⚠️️ throw in the future
    * - Fixme: ⚠️️ remove default value?
    */
   internal static func rgbaRep(data: Data, config: HCCQRSetup = .default) -> RGBARep? {
      let dataArr: [Data] = HCCQRConfigUtil.data(data: data, config: config) // splits data
      let ciImgs: [CIImage] = dataArr.concurrentCompactMap { (data: Data) in // parraelly create the qr-image-Layers
         try? QRWriter.ciImage(data: data, ecLevel: config.ecLevel) // Create B&W QR-layers (CIImage)
      }
      guard dataArr.count == ciImgs.count else { return nil } // if qrImgs was not created correctly etc
      // - Fixme: ⚠️️ benchmark how timeconsuming the colorization part is, if its worth doing parallel processing on
      let rgbaRep: RGBARep = Colorizer.colorize(qrLayers: ciImgs, config: config.output/*, coreCount: coreCount*/)
      return rgbaRep
   }
}
