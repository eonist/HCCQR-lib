import Foundation
import QR_lib
import CoreImage
/**
 * Creates HCCQR-Image from HCCQR-Data
 * - Fixme: ⚠️️ Rename to HCCQRWriter again
 */
public final class Writer2 {}

extension Writer2 {
   /**
    * - Fixme: ⚠️️ throw in the future
    * - Fixme: ⚠️️ create custom error cases
    */
   public static func image(data: Data, config: HCCQRSetup) -> Image? {
      let dataArr: [Data] = HCCQRConfigUtil.data(data: data, config: config)
      let ciImgs: [CIImage] = dataArr.concurrentMap { (data: Data) in // parraelly create the qr-image-Layers
         try? QRWriter.ciImage(data: data, ecLevel: config.ecLevel) // Create B&W QR-image
      }.compactMap { $0 }
      guard dataArr.count == ciImgs.count else { return nil } // if qrImgs was not created correctly etc
      // - Fixme: ⚠️️ Colorizer2 needs support for Rect, threadCount etc
      // 🏀 continue here
      guard let rgbaRep: RGBARep = try? Colorizer.colorize(ciImages: ciImgs, config: config.output) else { return nil }
      guard let image: Image = try? RGBARepParser.image(rgbaRep: rgbaRep, scale: CGFloat(config.scale.screen)) else { return nil }
      return image
   }
}
/**
 * Helper
 */
extension Writer2 { }
