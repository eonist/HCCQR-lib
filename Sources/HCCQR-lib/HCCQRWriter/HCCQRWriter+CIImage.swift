import Foundation
import QR_lib
import CoreImage

public final class HCCQRWriter {}
/**
 * Creates HCCQR from Data
 */
extension HCCQRWriter {
   /**
    * Data -> CIImage (New)
    * - Abstract: Create two QR images from the data, and combine them into RGBAImage, then convert that to CIImage
    * - Important: The caller must make sure the qrVersion can hold the amount of chars in string
    * - Fixme: ⚠️️ Add support for more colors by adding colorDepth: Int in params
    * - Fixme: ⚠️️ Threading shouldn't be done here I think. maybe use WorkItems, nsoperation, semphore etc, do more research, concurrent_apply?, Dispatchgroups?
    * ## Example:
    * let (qrVersion, qrMode, ecLevel): QRConfig = (10, .byte, .l) // settings
    * guard let data: String = HCCQRStringData.randomData(qrVersion: qrVersion, qrMode: qrMode, ecLevel:ecLevel) else { Swift.print("unable to create random string"); return }
    * HCCQRWriter.ciImage(data: data, multiplier: (moduleScale: 6, screenScale: 2), qrConfig: (qrVersion, ecLevel), onComplete: { ciImg in Swift.print("ciImg: \(ciImg)") })
    * - Parameters:
    *   - data: The data to be embedded into the HCCQR-image
    *   - qrConfig: we supply version because it's more optimized than calculating moduleCount on the basis of data.count
    *   - multipliers: for retina you need 2x scale etc,  ModuleCount equals 1 pixel. ModuleMultiplier scales this
    *   - onComplete: callback when the image has been produced
    */
   public static func ciImage(data: Data, multipliers: Multipliers, qrConfig: QRConfig = (.v10, .l), onComplete: @escaping OnHCCQRCIImageCompleted) {
      let dataArr: [Data] = data.split(index: data.count / 2) // Split the data in two
      var ciImgs: [CIImage?] = [CIImage?](repeating: nil, count: dataArr.count) // Pre-filled array for the images
      dataArr.enumerated().forEach { (_ offset: Int, _ data: Data) in
         DispatchQueue.global(qos: .userInitiated).async { // Do the operation on a background-thread
            let ciImg: CIImage? = try? QRWriter.ciImage(data: data, ecLevel: qrConfig.ecLevel) // Create B&W QR-image
            DispatchQueue.main.async { // I guess main-thread is needed here because we access an array
               onCreateCIImgComplete(i: offset, ciImg: ciImg, ciImgs: &ciImgs, multipliers: multipliers, onComplete: onComplete)
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
    * onCreateCIImgComplete (New)
    * - Note: Used in the process of converting Data to HCCQR
    */
   private static func onCreateCIImgComplete(i: Int, ciImg: CIImage?, ciImgs:inout [CIImage?], multipliers: Multipliers, onComplete: OnHCCQRCIImageCompleted) {
      guard let ciImg: CIImage = ciImg else { onComplete(.failure(NSError(domain: "ciImg err ", code: 0))); return }
      ciImgs[i] = ciImg // It matters which order the qrImages came in when you stitch them back together
      if ciImgs.first(where: { $0 == nil }) == nil { // Makes sure all images finished (aka no nil values)
         let ciImages: [CIImage] = ciImgs.compactMap { $0 } // Remove nils
         let result: Colorizer.ColorizedResult = Colorizer.colorize(ciImages: ciImages, colorMap: Colorizer.colorMap(), multipliers: multipliers)
         guard let hccqrImage: CIImage = try? result.get() else { onComplete(.failure(NSError(domain: "onCreateCIImgComplete() - Unable to create colorized image: \(result.errorStr)", code: 0))); return }
         onComplete(.success(hccqrImage))
      }
   }
}
