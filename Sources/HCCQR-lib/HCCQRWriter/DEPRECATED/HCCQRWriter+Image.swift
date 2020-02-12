import Foundation
import QR_lib
import CoreImage
/**
 * Creates HCCQR from Data
 */
extension HCCQRWriter {
   /**
    * Data -> Image (⚠️️⚠️️⚠️️ DEPRECATE SOON, because we use Data - CIImage now ⚠️️⚠️️⚠️️)
    * - Note: For more in-depth example see repo readme
    * - Important: The caller must make sure the qrVersion can hold the amount of chars in string
    * - Important: Remember to add the resulting img to view within main.thread
    * - Note: use `Swift.print(hccqrImage?.hasOnlyColorMap(colorMap: [.red, .green, .blue, .white]))`//ensure that img only has valid colors, akak no bluring
    * - Fixme: ⚠️️ Add support for more colors by adding colorDepth: Int in params
    * - Fixme: ⚠️️ Threading shouldn't be done here I think. maybe use WorkItems, nsoperation, semphore etc, do more research, concurrent_apply?, Dispatchgroups?
    * ## Example:
    * let (qrVersion, qrMode, ecLevel): QRConfig = (10, .byte, .l) // settings
    * guard let randomString: String = HCCQRStringData.randomString(qrVersion: qrVersion, qrMode: qrMode, ecLevel:ecLevel) else { Swift.print("unable to create random string"); return }
    * guard let data = randomString.data(using: .utf8) else { Swift.print("err data");return }
    * HCCQRImageUtil.getHCCQRImage(data: data, moduleMultiplier: 6, scale: 2, qrConfig: (qrVersion, ecLevel), onComplete: { img in Swift.print("img.size:  \(img?.size)") })
    * - Parameters:
    *   - data: The data to be embedded into the HCCQR-image
    *   - qrConfig: we supply version because it's more optimized than calculating moduleCount on the basis of data.count
    *   - multipliers: for retina you need 2x scale etc,  ModuleCount equals 1 pixel. ModuleMultiplier scales this
    *   - onComplete: callback when the image has been produced
    */
   public static func image(data: Data, multipliers: Multipliers, qrConfig: QRConfig = (.v10, .l), onComplete: @escaping OnHCCQRImageCompleted) {
      let dataArr: [Data] = data.split(index: data.count / 2) // Split the data in two
      var qrImgs: [Image?] = [Image?](repeating: nil, count: dataArr.count) // Pre-filled array for the images
      dataArr.enumerated().forEach { (_ offset: Int, _ data: Data) in
         DispatchQueue.global(qos: .userInitiated).async { // Do the operation on a background-thread
            let qrImg: Image? = try? QRWriter.image(data: data, ecLevel: qrConfig.ecLevel) // Create B&W QR-image
            DispatchQueue.main.async { // I guess main-thread is needed here because we access an array
               onCreateQrImgComplete(i: offset, qrImg: qrImg, qrImgs: &qrImgs, multipliers: multipliers, onComplete: onComplete)
            }
         }
      }
   }
}
/**
 * Private static handler
 */
extension HCCQRWriter {
   /**
    * (⚠️️⚠️️⚠️️ DEPRECATE SOON ⚠️️⚠️️⚠️️)
    * - Fixme: ⚠️️ try to get rid of the inout method
    * - Fixme: ⚠️️ Needs refactor, try using NSOperation or Semaphors
    */
   private static func onCreateQrImgComplete(i: Int, qrImg: Image?, qrImgs:inout [Image?], multipliers: Multipliers, onComplete: OnHCCQRImageCompleted) {
      guard let qrImg: Image = qrImg else { onComplete(.failure(NSError(domain: "qrImg err ", code: 0))); return }
      qrImgs[i] = qrImg // It matters which order the QRImages came in when you stitch them back together
      if qrImgs.first(where: { $0 == nil }) == nil { // Makes sure all images finished (aka no nil values)
         let qrImages: [Image] = qrImgs.compactMap { $0 } // Remove nils
         guard let hccqrImage: Image = try? Colorizer.colorize(images: qrImages, colorMap: Colorizer.colorMap(), multipliers: multipliers) else { onComplete(.failure(NSError(domain: "onCreateQrImgComplete() -Unable to create colorized image", code: 0))); return }
         onComplete(.success(hccqrImage))
      }
   }
}
