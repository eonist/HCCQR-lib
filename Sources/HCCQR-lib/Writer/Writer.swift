import Foundation
import QR_lib
import CoreImage
/**
 * Creates HCCQR-Image from binary Data
 */
public final class Writer {}

extension Writer {
   /**
    * Data 👉 RGBAImage 👉 Image (Async)
    * 1. Data comes in with config and scale
    * 2. Converts data to RGBARep
    * 3. Converts RGBARep to Image
    * - Fixme: ⚠️️ Could setting CIImage or CGIMage directly to a Image in the UI be faster?
    * - Fixme: ⚠️️ Try a sync version of this method with semphors
    * - Note: Supports The grayscaleImage optimization
    */
   public static func image(data: Data, config: HCCQRSetup, onComplete: @escaping OnWriteComplete) {
      rgbaRep(data: data, config: config) { (result: RGBRepResult) in
         guard let rgbaRep: RGBARep = try? result.get() else { onComplete(.failure(.unableToCreateRGBAImage(errMSG: result.errorStr))); return }
         defer { rgbaRep.deInitiate() } // De alloc rgbaImage when it servers no purpouse anymore
         guard let image: Image = try? RGBARepParser.image(rgbaRep: rgbaRep, scale: CGFloat(config.scale.screen)) else { onComplete(.failure(.unableToConvertRGBAToImage)); return }
         onComplete(.success(image))
      }
   }
}
/**
 * Quadrant optimization test
 */
extension Writer {
   /**
    * - Fixme: ⚠️️ throw in the future
    * - Fixme: ⚠️️ create custom error cases
    * - Parameters:
    *   - data: data to be converted to HCCQR
    *   - config: config of HCCQR
    *   - coreCount: num of cores on computer, used to divide tasks efficiently (ProcessInfo().activeProcessorCount)
    */
   public static func img(data: Data, config: HCCQRSetup, coreCount: Int) -> Image? {
      let dataArr: [Data] = HCCQRConfigUtil.data(data: data, config: config) // splits data
      let ciImgs: [CIImage] = dataArr.concurrentMap { (data: Data) in // parraelly create the qr-image-Layers
         try? QRWriter.ciImage(data: data, ecLevel: config.ecLevel) // Create B&W QR-layers (CIImage)
      }.compactMap { $0 }
      guard dataArr.count == ciImgs.count else { return nil } // if qrImgs was not created correctly etc
      // - Fixme: ⚠️️ benchmark how timeconsuming the colorization part is, if its worth doing parallel processing on
      let rgbaRep: RGBARep = Colorizer.colorize(qrLayers: ciImgs, config: config.output, coreCount: coreCount)
      guard let image: Image = try? RGBARepParser.image(rgbaRep: rgbaRep, scale: CGFloat(config.scale.screen)) else { return nil }
      return image
   }
}
/**
 * Internal static helper
 */
extension Writer {
   /**
    * Data 👉 [CIImage's] 👉 RGBARep
    * 1. Data comes in with config and scale
    * 2. Splits the data into two
    * 3. Creates 2 CIImage's of these two data items
    * - Abstract: Create two QR images from the data, and combine them into RGBAImage, then convert that to CIImage
    * - Caution: ⚠️️ Remember to deinit the result once it's consumed
    * - Important: internal because: SingleWriteReadHCCQRTest and BulkHCCQRTest uses it for tests
    * - Fixme: ⚠️️ Splitting the data in two allows 4 color map, in the future we will allow 8 color map etc (pallet etc)
    */
   internal static func rgbaRep(data: Data, config: HCCQRSetup = .default, onComplete: @escaping OnRGBRepComplete) {
      let dataArr: [Data] = HCCQRConfigUtil.data(data: data, config: config)
      var ciImgs: [CIImage?] = [CIImage?](repeating: nil, count: dataArr.count) // Pre-filled array for the images
      dataArr.enumerated().forEach { (offset: Int, data: Data) in
         DispatchQueue.global(qos: .userInitiated).async { // Adds the operation to a background-thread
            let ciImg: CIImage? = try? QRWriter.ciImage(data: data, ecLevel: config.ecLevel) // Create B&W QR-image
            DispatchQueue.main.async { // I guess main-thread is needed here because we access an array
               onQRImageComplete(i: offset, ciImg: ciImg, ciImgs: &ciImgs, config: config, onComplete: onComplete)
            }
         }
      }
   }
}
