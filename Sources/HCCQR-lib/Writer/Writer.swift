import Foundation
import QR_lib
import CoreImage
/**
 * Creates HCCQR-Image from HCCQR-Data
 * - Fixme: ⚠️️ Rename to HCCQRWriter again
 */
public final class Writer {}

extension Writer {
   /**
    * Converts Data -> RGBAImage -> Image (Async)
    * 1. Data comes in with config and scale
    * 2. Converts data to RGBAImage
    * 3. Converts RGBAImage to Image
    * - Fixme: ⚠️️ Could setting CIImage or CGIMage directly to a Image in the UI be faster?
    * - Fixme: ⚠️️ Try a sync version of this method with semphors
    * - Note: Supports The grayscaleImage optimization
    */
   public static func image(data: Data, scale: Scale, qrConfig: HCCQRConfig = defaultQRConfig, useDarkMode: Bool = false, onComplete: @escaping OnImageComplete) {
      rgbaImage(data: data, multipliers: scale, qrConfig: qrConfig, useDarkMode: useDarkMode) { result in
         guard let rgbaRep: RGBARep = try? result.get() else { onComplete(.failure(.unableToCreateRGBAImage(errMSG: result.errorStr))); return }
         guard let image: Image = try? RGBARepParser.image(rgbaRep: rgbaRep, scale: CGFloat(scale.screen)) else { onComplete(.failure(.unableToConvertRGBAToImage)); return }
         rgbaRep.deinitiate() // De alloc rgbaImage when it servers no purpouse anymore
         onComplete(.success(image))
      }
   }
}
/**
 * Private static helper
 */
extension Writer {
   /**
    * Converts Data -> [CIImage's] -> RGBAImage
    * 1. Data comes in with config and scale
    * 2. Splits the data into two
    * 3. Creates 2 CIImage's of these two data items
    * - Abstract: Create two QR images from the data, and combine them into RGBAImage, then convert that to CIImage
    * - Caution: ⚠️️ Remember to deinit the result once it's consumed
    * - Important: internal because: SingleWriteReadHCCQRTest and BulkHCCQRTest uses it for tests
    * - Fixme: ⚠️️ Splitting the data in two allows 4 color map, in the future we will allow 8 color map (pallet etc)
    */
   internal static func rgbaImage(data: Data, multipliers: Scale, qrConfig: HCCQRConfig = defaultQRConfig, useDarkMode: Bool = false, onComplete: @escaping OnRGBAImageComplete) {
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
}
