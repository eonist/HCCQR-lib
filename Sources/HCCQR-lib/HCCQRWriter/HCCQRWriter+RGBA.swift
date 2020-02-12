import Foundation
import QR_lib
import CoreImage
/**
 * Creates HCCQR-Image from HCCQR-Data
 */
extension HCCQRWriter {
   /**
    * Converts Data -> Image (Async)
    * 1. Data comes in with config and scale
    * 2. Converts data to RGBAImage
    * 3. Converts RGBAImage to Image
    * - Fixme: ⚠️️ Could setting CIImage or CGIMage directly to a Image in the UI be faster?
    * - Fixme: ⚠️️ Try a sync version of this method with semphors
    * - Note: Supports The grayscaleImage optimization
    */
   public static func img(data: Data, multipliers: Multipliers, qrConfig: QRConfig = (.v10, .l), useDarkMode: Bool = false, onComplete: @escaping OnHCCQRImageCompleted) {
      rgbaImage(data: data, multipliers: multipliers, qrConfig: qrConfig, useDarkMode: useDarkMode) { result in
         guard let rgbaImg: RGBAImage = try? result.get() else { onComplete(.failure(NSError("\(result.errorStr)"))); return }
         guard let image: Image = try? RGBAImageUtil.image(rgbaImage: rgbaImg, scale: CGFloat(multipliers.screenScale)) else { onComplete(.failure(NSError("Colorize.colorize() - Unable to convert to UIImage"))); return }
         rgbaImg.deinitiate() // Dealloc rgbaImage when it servers no purpouse anymore
         onComplete(.success(image))
      }
   }
   /**
    * Data -> CIImage
    * 1. Data comes in with config and scale
    * 2. Splits the data into two
    * 3. Creates 2 CIImage's of these two data items
    * - Abstract: Create two QR images from the data, and combine them into RGBAImage, then convert that to CIImage
    * - Caution: ⚠️️ Remember to deinit the result once it's consumed
    */
   public static func rgbaImage(data: Data, multipliers: Multipliers, qrConfig: QRConfig = (.v10, .l), useDarkMode: Bool = false, onComplete: @escaping OnRGBAImageComplete) {
      let dataArr: [Data] = data.split(index: data.count / 2) // Split the data in two
      var ciImgs: [CIImage?] = [CIImage?](repeating: nil, count: dataArr.count) // Pre-filled array for the images
      dataArr.enumerated().forEach { (_ offset: Int, _ data: Data) in
         DispatchQueue.global(qos: .userInitiated).async { // Adds the operationto a background-thread
            let ciImg: CIImage? = try? QRWriter.ciImage(data: data, ecLevel: qrConfig.ecLevel) // Create B&W QR-image
            DispatchQueue.main.async { // I guess main-thread is needed here because we access an array
               onCIImagesComplete(i: offset, ciImg: ciImg, ciImgs: &ciImgs, multipliers: multipliers, useDarkMode: useDarkMode, onComplete: onComplete)
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
    * - Fixme: ⚠️️ add step doc 
    */
   private static func onCIImagesComplete(i: Int, ciImg: CIImage?, ciImgs:inout [CIImage?], multipliers: Multipliers, useDarkMode: Bool = false, onComplete: OnRGBAImageComplete) {
      guard let ciImg: CIImage = ciImg else { onComplete(.failure(NSError(domain: "ciImg err ", code: 0))); return }
      ciImgs[i] = ciImg // It matters which order the qrImages came in when you stitch them back together
      if ciImgs.first(where: { $0 == nil }) == nil { // Makes sure all images finished (aka no nil values)
         let ciImages: [CIImage] = ciImgs.compactMap { $0 } // Remove nils
         let colorMap: Colorizer.ColorMap = Colorizer.colorMap(useDarkMode: useDarkMode)
         guard let rgbaImage: RGBAImage = try? Colorizer.grayscaleColorize(ciImages: ciImages, colorMap: colorMap, multipliers: multipliers) else { onComplete(.failure(NSError(domain: "onCreateCIImgComplete() - Unable to create colorized image", code: 0))); return }
         onComplete(.success(rgbaImage))
      }
   }
}
