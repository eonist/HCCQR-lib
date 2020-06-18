import Foundation
import QR_lib
import QuartzCore
import CoreImage
/**
 * Adds support for CVImageBuffer (For processing data from camera)
 * - Fixme: ⚠️️ Maybe Rename to Writer.swift?
 */
extension HCCQRReader {
   /**
    * ImageBuffer -> DataAndQuad
    * 1. Create RGBA representation of the CVImageBuffer
    * 2. Split the RGBA into multiple QR-Images
    * 3. Extract the data from the QR-Images
    * 4. Combine the multiple Data's into one Data
    * 5. Return the data and the meta-data
    * - Parameters:
    *   - imageBuffer: The buffer containing the raw pixel data and size
    *   - crop: Makes processing the raw imagery faster since we don't have to process areas where the QR info is not etc.
    *   - onComplete: Return Data and Meta-data in this completion-block
    */
   public static func dataAndMeta(imageBuffer: CVImageBuffer, crop: BufferRect, onComplete: @escaping OnGetDataAndMetaCompleted) {
      guard let rgbaImg: RGBAImage = try? CVImageBufferUtil.rgbaImage(imageBuffer: imageBuffer, crop: crop) else { onComplete(.failure(ReadError.unableToExtractRGBAImageFromCVBuffer)); return }
      dataAndImages(rgbaImage: rgbaImg) { (result: HCCQRReader.DataAndImagesResult) in
         guard let dataAndImagesAndQuad: HCCQRReader.DataAndImages = try? result.get() else { onComplete(.failure(.unableToGetDataAndImages(msg: result.errorStr))); return }
         guard let data: Data = dataAndImagesAndQuad.data, let quad = dataAndImagesAndQuad.quad  else { onComplete(.failure(.unableToGetDataOrQuad)); return }
         let dataAndMeta: DataAndMeta = (data: data, quad: quad, imageSize: rgbaImg.cgSize)
         onComplete(.success(dataAndMeta))
      }
   }
}
