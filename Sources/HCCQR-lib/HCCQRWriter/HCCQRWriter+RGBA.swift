import Foundation
import QR_lib
import CoreImage
/**
 * Creates HCCQR from Data
 */
extension HCCQRWriter {
   /**
    * Data -> Image (⚠️️ new ⚠️️)
    * - Note: Supports The grayscaleImage optimization
    */
   public static func img(data: Data, multipliers: Multipliers, qrConfig: QRConfig = (.v10, .l), onComplete: @escaping OnHCCQRImageCompleted) {
      HCCQRWriter.rgbaImage(data: data, multipliers: multipliers, qrConfig: qrConfig) { result in
         guard let rgbaImg = try? result.get() else { onComplete(.failure(NSError("\(result.errorStr)"))); return }
         guard let image: Image = try? RGBAImageUtil.image(rgbaImage: rgbaImg, scale: CGFloat(multipliers.screenScale)) else { onComplete(.failure(NSError("Colorize.colorize() - Unable to convert to UIImage"))); return }
         onComplete(.success(image))
      }
   }
   /**
    * Data -> CIImage (New)
    * - Abstract: Create two QR images from the data, and combine them into RGBAImage, then convert that to CIImage
    */
   public static func rgbaImage(data: Data, multipliers: Multipliers, qrConfig: QRConfig = (.v10, .l), onComplete: @escaping OnRGBAImageComplete) {
      //      Swift.print("HCCQRWriter.ciImage()")
      let dataArr: [Data] = data.split(index: data.count / 2) // Split the data in two
      var ciImgs: [CIImage?] = [CIImage?](repeating: nil, count: dataArr.count) // Pre-filled array for the images
      dataArr.enumerated().forEach { (_ offset: Int, _ data: Data) in
         DispatchQueue.global(qos: .userInitiated).async { // Do the operation on a background-thread
            let ciImg: CIImage? = try? QRWriter.ciImage(data: data, ecLevel: qrConfig.ecLevel) // Create B&W QR-image
            DispatchQueue.main.async { // I guess main-thread is needed here because we access an array
               onCreateRGBAComplete(i: offset, ciImg: ciImg, ciImgs: &ciImgs, multipliers: multipliers, onComplete: onComplete)
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
   private static func onCreateRGBAComplete(i: Int, ciImg: CIImage?, ciImgs:inout [CIImage?], multipliers: Multipliers, onComplete: OnRGBAImageComplete) {
      guard let ciImg: CIImage = ciImg else { onComplete(.failure(NSError(domain: "ciImg err ", code: 0))); return }
      ciImgs[i] = ciImg // It matters which order the qrImages came in when you stitch them back together
      if ciImgs.first(where: { $0 == nil }) == nil { // Makes sure all images finished (aka no nil values)
         let ciImages: [CIImage] = ciImgs.compactMap { $0 } // Remove nils
         guard let rgbaImage: RGBAImage = try? Colorizer.grayscaleColorize(ciImages: ciImages, colorMap: Colorizer.colorMap, multipliers: multipliers) else { onComplete(.failure(NSError(domain: "onCreateCIImgComplete() - Unable to create colorized image", code: 0))); return }
         onComplete(.success(rgbaImage))
      }
   }
}
