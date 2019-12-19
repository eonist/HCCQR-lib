import Foundation
import QR_lib
import CoreImage
/**
 * Creates HCCQR from Data
 */
extension HCCQRWriter {
   /**
    * ciImage (New)
    */
   public static func ciImage(data: Data, multipliers: Multipliers, qrConfig: QRConfig = (.v10, .l), onComplete: @escaping OnHCCQRCIImageCompleted) {
      Swift.print("ciImage")
      let dataArr: [Data] = data.split(index: data.count / 2) // Split the data in two
      var ciImgs: [CIImage?] = [CIImage?](repeating: nil, count: dataArr.count) // Pre-filled array for the images
      dataArr.enumerated().forEach { (_ offset: Int, _ data: Data) in
         DispatchQueue.global(qos: .userInitiated).async { // Do the operation on a background-thread
            let ciImg: CIImage? = try? QRWriter.ciImage(data: data, ecLevel: qrConfig.ecLevel) // Create B&W QR-image
//            Swift.print("ciImg \(ciImg?.extent.size)")
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
    */
   private static func onCreateCIImgComplete(i: Int, ciImg: CIImage?, ciImgs:inout [CIImage?], multipliers: Multipliers, onComplete: OnHCCQRCIImageCompleted) {
      guard let ciImg: CIImage = ciImg else { onComplete(.failure(NSError(domain: "ciImg err ", code: 0))); return }
      ciImgs[i] = ciImg // It matters which order the qrImages came in when you stitch them back together
      if ciImgs.first(where: { $0 == nil }) == nil { // Makes sure all images finished (aka no nil values)
         let ciImages: [CIImage] = ciImgs.compactMap { $0 } // Remove nils
         // - fixme: ⚠️️ make colorize a result, so you can pass on the error msg
         guard let hccqrImage: CIImage = try? Colorizer.colorize(ciImages: ciImages, colorMap: Colorizer.colorMap, multipliers: multipliers) else { onComplete(.failure(NSError(domain: "onCreateCIImgComplete() - Unable to create colorized image", code: 0))); return }
         onComplete(.success(hccqrImage))
      }
   }
}
/**
 * Typealias
 */
extension HCCQRWriter {
   public typealias OnHCCQRCIImageCompleted = (Result<CIImage, Error>) -> Void
}
