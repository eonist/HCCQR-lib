import Foundation
import QR_lib
import QuartzCore
import CoreImage

public final class Reader {}
/**
 * Adds support for CVImageBuffer (For processing data from camera)
 */
extension Reader {
   /**
    * CVImageBuffer -> Data
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
      guard let rgbaImg: RGBARep = try? CVImageBufferUtil.rgbaRep(imageBuffer: imageBuffer, crop: crop) else { onComplete(.failure(.unableToExtractRGBAImageFromCVBuffer)); return }
      dataAndImages(rgbaImage: rgbaImg) { (result: Reader.DataAndImagesResult) in
         guard let dataAndImagesAndQuad: DataAndImages = try? result.get() else { onComplete(.failure(.unableToGetDataAndImages(msg: result.errorStr))); return }
         guard let data: Data = dataAndImagesAndQuad.data, let quad = dataAndImagesAndQuad.quad  else { onComplete(.failure(.unableToGetDataOrQuad)); return }
         let dataAndMeta: DataAndMeta = (data: data, quad: quad, imageSize: rgbaImg.cgSize)
         onComplete(.success(dataAndMeta))
      }
   }
}
/**
 * RGBARep -> data
 */
extension Reader {
   /**
    * Creates data for HCCQQR image (RGBAImage)
    * - Abstract: Since we get pixel data from the camera, this will be faster than converting to image first
    * - Fixme: ⚠️️ When the first QRImage Quad is found, the subsequent QR-Rects will be in the same quadrant, clip the subsequent images
    * - Fixme: ⚠️️ I don't think returning qrimage is useful anymore, it was used as a way to debug that the HCCQR ws split correctly
    * - Note: Isn't private because Reader+CVIUmageBuffer calls it
    * - Parameters:
    *   - rgbaImage: raw pixels and size
    *   - onComplete: completion block
    */
   static func dataAndImages(rgbaImage: RGBARep, onComplete:@escaping DataAndImageCompleted) {
      Splitter.split(rgbaImage: rgbaImage) { (result: Splitter.Payload) in // Start the splitting process
         onSplitComplete(result: result, onComplete: onComplete) // readTime += abs(HCCQRReader.splitTime.timeIntervalSinceNow); Swift.print("👉 Splitting rgbaImage done: \(abs(HCCQRReader.splitTime.timeIntervalSinceNow))")
      }
   }
}
