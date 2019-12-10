import Foundation
import QR_lib
/**
 * Creates HCCQR from Data
 */
public final class HCCQRWriter {
   /**
    * Returns an HCCQR UIImage for a string
    * - Note: For more in-depth example see repo readme
    * - Important: The caller must make sure the qrVersion can hold the amount of chars in string
    * - Important: Remember to add the resulting img to view within main.thread
    * - Note: use `Swift.print(hccqrImage?.hasOnlyColorMap(colorMap: [.red, .green, .blue, .white]))`//ensure that img only has valid colors, akak no bluring
    * - Fixme: ⚠️️ Add support for more colors by adding colorDepth: Int in params
    * ## Example:
    * let (qrVersion, qrMode, ecLevel): HCCQRConfig = (10, .byte, .l) // settings
    * guard let randomString: String = HCCQRStringData.randomString(qrVersion: qrVersion, qrMode: qrMode, ecLevel:ecLevel) else { Swift.print("unable to create random string");return }
    * guard let data = randomString.data(using: .utf8) else { Swift.print("err data");return }
    * HCCQRImageUtil.getHCCQRImage(data:data,moduleMultiplier: 6, scale: 2, qrConfig: (qrVersion, ecLevel), onComplete: { img in Swift.print("img.size:  \(img?.size)") })//
    * - Parameters:
    *   - data: The data to be embedded into the HCCQR-image
    *   - moduleMultiplier: ModuleCount equals 1 pixel. ModuleMultiplier scales this
    *   - qrConfig: we supply version because it's more optimized than calculating moduleCount on the basis of data.count
    *   - scale: for retina you need 2x scale etc
    */
   public static func image(data: Data, multipliers: Multipliers, qrConfig: QRConfig = (10, .l), onComplete: @escaping OnHCCQRImageComplete) {
      let dataArr: [Data] = data.split(index: data.count / 2) // Split the data in two
      var qrImgs: [Image?] = [Image?](repeating: nil, count: dataArr.count) // Pre-filled array for the images
      dataArr.enumerated().forEach { (_ offset: Int, _ data: Data) in
         DispatchQueue.global(qos: .userInitiated).async { // do the operation on a background-thread
            let qrImg: Image? = try? QRWriter.image(data: data, ecLevel: qrConfig.ecLevel) // create B&W QR-image
            DispatchQueue.main.async { // I guess mainthread is needed here because we access an array
               onCreateQrImgComplete(i: offset, qrImg: qrImg, qrImgs: &qrImgs, multipliers: multipliers, onComplete: onComplete)
            }
         }
      }
   }
}
/**
 * Private static helper
 */
extension HCCQRWriter {
   /**
    * - Fixme: ⚠️️ try to get rid of the inout method
    * - Fixme: ⚠️️ Needs refactor, try using NSOperation or Semaphors
    */
   private static func onCreateQrImgComplete(i: Int, qrImg: Image?, qrImgs:inout [Image?], multipliers: Multipliers, onComplete: OnHCCQRImageComplete) {
      guard let qrImg: Image = qrImg else { onComplete(nil, "HCCQRWriter.image() - onCreateQrImgComplete() - ⚠️️ qrImg err ⚠️️ "); return }
      qrImgs[i] = qrImg // it matters which order the qrImages came in when you stitch them back together
      if qrImgs.first(where: { $0 == nil }) == nil { // makes sure all images finished (aka no nil values)
         let qrImages: [Image] = qrImgs.compactMap { $0 } // remove nils
         guard let hccqrImage: Image = try? Colorizer.colorize(images: qrImages, colorMap: Colorizer.colorMap, multipliers: multipliers) else { onComplete(nil, "getHCCQRImage - Unable to create colorized image"); return }
         onComplete(hccqrImage, nil)
      }
   }
}
