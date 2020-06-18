import Foundation
import QR_lib
import CoreImage
/**
 * Creates HCCQR-Image from HCCQR-Data
 * - Fixme: ⚠️️ Maybe Rename to Writer.swift?
 */
public final class HCCQRWriter {}

extension HCCQRWriter {
   /**
    * Converts Data -> RGBAImage -> Image (Async)
    * 1. Data comes in with config and scale
    * 2. Converts data to RGBAImage
    * 3. Converts RGBAImage to Image
    * - Fixme: ⚠️️ Could setting CIImage or CGIMage directly to a Image in the UI be faster?
    * - Fixme: ⚠️️ Try a sync version of this method with semphors
    * - Note: Supports The grayscaleImage optimization
    */
   public static func image(data: Data, multipliers: Multipliers, qrConfig: QRConfig = defaultQRConfig, useDarkMode: Bool = false, onComplete: @escaping OnImageComplete) {
      rgbaImage(data: data, multipliers: multipliers, qrConfig: qrConfig, useDarkMode: useDarkMode) { result in
         guard let rgbaImg: RGBAImage = try? result.get() else { onComplete(.failure(.unableToCreateRGBAImage(errMSG: result.errorStr))); return }
         guard let image: Image = try? RGBAImageUtil.image(rgbaImage: rgbaImg, scale: CGFloat(multipliers.screen)) else { onComplete(.failure(.unableToConvertRGBAToImage)); return }
         rgbaImg.deinitiate() // De alloc rgbaImage when it servers no purpouse anymore
         onComplete(.success(image))
      }
   }
}
/**
 * Private static helper
 */
extension HCCQRWriter {
   /**
    * Converts Data -> [CIImage's] -> RGBAImage
    * 1. Data comes in with config and scale
    * 2. Splits the data into two
    * 3. Creates 2 CIImage's of these two data items
    * - Abstract: Create two QR images from the data, and combine them into RGBAImage, then convert that to CIImage
    * - Caution: ⚠️️ Remember to deinit the result once it's consumed
    * - Important: internal because: BulkHCCQRTest uses it for tests
    * - Fixme: ⚠️️ Splitting the data in two allows 4 color map, in the future we will allow 8 color map (pallet etc)
    */
   internal static func rgbaImage(data: Data, multipliers: Multipliers, qrConfig: QRConfig = defaultQRConfig, useDarkMode: Bool = false, onComplete: @escaping OnRGBAImageComplete) {
      let dataArr: [Data] = data.split(index: data.count / 2) // Split the data in two ()
      var ciImgs: [CIImage?] = [CIImage?](repeating: nil, count: dataArr.count) // Pre-filled array for the images
      dataArr.enumerated().forEach { (_ offset: Int, _ data: Data) in
         DispatchQueue.global(qos: .userInitiated).async { // Adds the operation to a background-thread
            let ciImg: CIImage? = try? QRWriter.ciImage(data: data, ecLevel: qrConfig.ecLevel) // Create B&W QR-image
            DispatchQueue.main.async { // I guess main-thread is needed here because we access an array
               onQRImageComplete(i: offset, ciImg: ciImg, ciImgs: &ciImgs, multipliers: multipliers, useDarkMode: useDarkMode, onComplete: onComplete)
            }
         }
      }
   }
   /**
    * onCreateCIImgComplete (New)
    * - Note: Used in the process of converting Data to HCCQR
    * 1. CIImage's comes in
    * 2. When the result array is full of CIImages the colorizing starts
    * 3. Colorize grayscale CIImages
    * 4. return RGBA image
    * - Important: ⚠️️ We could get raw grayscale or even bool info, but for now we use apples qr-creation method, and that uses CIImage as output
    * - Parameters:
    *   - i: the index of the CIImage to be placed in the result-array
    *   - ciImg: The image to be placed in the result-array
    *   - ciImgs: The completion result array (initially populated with nils)
    *   - multipliers: Screen and module scale
    *   - useDarkMode: Toggle between dark and light mode (dark / white background)
    *   - onComplete: Return the complete HCCQR image from grayscale QR represenations
    */
   private static func onQRImageComplete(i: Int, ciImg: CIImage?, ciImgs:inout [CIImage?], multipliers: Multipliers, useDarkMode: Bool = false, onComplete: OnRGBAImageComplete) {
      guard let ciImg: CIImage = ciImg else { onComplete(.failure(.unableToCreateCIImage)); return }
      ciImgs[i] = ciImg // It matters which order the QRImage's came in when you stitch them back together
      if !ciImgs.contains(where: { $0 == nil }) { // Makes sure all images finished (aka no nil values)
         let ciImages: [CIImage] = ciImgs.compactMap { $0 } // Removes nils
         let colorMap: Colorizer.ColorMap = Colorizer.colorMap(useDarkMode: useDarkMode)
         guard let rgbaImage: RGBAImage = try? Colorizer.colorize(ciImages: ciImages, colorMap: colorMap, multipliers: multipliers) else { onComplete(.failure(.unableToCreateColorizedImage)); return }
         onComplete(.success(rgbaImage))
      }
   }
}
