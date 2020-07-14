import Foundation
import QR_lib
import QuartzCore
import CoreImage
/**
 * Reads HCCQR into binary data
 */
public final class Reader {}
/**
 * Adds support for CVImageBuffer (For processing data from camera)
 */
extension Reader {
   /**
    * CVImageBuffer -> Data
    * - Fixme: ⚠️️ Rename to just data
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
   public static func data(imageBuffer: CVImageBuffer, crop: BufferRect, onComplete: @escaping OnReadCompleted) {
      guard let rgbaImg: RGBARep = try? BufferUtil.rgbaRep(imageBuffer: imageBuffer, crop: crop) else { onComplete(.failure(.unableToExtractRGBAImageFromCVBuffer)); return }
      data(rgbaRep: rgbaImg) { (result: Reader.ReadResult2) in
         guard let dataAndImagesAndQuad: ReadPayload2 = try? result.get() else { onComplete(.failure(.unableToGetDataAndImages(msg: result.errorStr))); return }
         guard let data: Data = dataAndImagesAndQuad.data, let quad = dataAndImagesAndQuad.quad  else { onComplete(.failure(.unableToGetDataOrQuad)); return }
         let dataAndMeta: ReadPayload = (data: data, quad: quad, imageSize: rgbaImg.cgSize)
         onComplete(.success(dataAndMeta))
      }
   }
}
/**
 * RGBARep -> Data & QR
 */
extension Reader {
   /**
    * Creates data for HCCQQR image (RGBAImage)
    * - Fixme: ⚠️️ Rename to just data
    * - Abstract: Since we get pixel data from the camera, this will be faster than converting to image first
    * - Fixme: ⚠️️ When the first QRImage Quad is found, the subsequent QR-Rects will be in the same quadrant, clip the subsequent images
    * - Note: returning qrimage is useful, it is used as a way to debug that the HCCQR ws split correctly
    * - Note: Isn't private because Reader+CVIUmageBuffer calls it
    * - Parameters:
    *   - rgbaRep: raw pixels and size
    *   - onComplete: completion block
    */
   internal static func data(rgbaRep: RGBARep, pallete: ChannelPallete = .default, onComplete: @escaping OnReadCompleted2) {
      Splitter.split(rgbaRep: rgbaRep, pallete: pallete) { (result: Splitter.SplitResult) in // Start the splitting process
         onSplitComplete(result: result, onComplete: onComplete) // readTime += abs(HCCQRReader.splitTime.timeIntervalSinceNow); Swift.print("👉 Splitting rgbaImage done: \(abs(HCCQRReader.splitTime.timeIntervalSinceNow))")
      }
   }
}
/**
 * Support for parallel reading of input
 */
extension Reader {
   /**
    * Reads rgbaRep (support for parallel processing) (⚠️️ New ⚠️️)
    * - Note: the QRReader doesn't like to be processes parralelly
    */
   public static func data(rgbaRep: RGBARep, pallete: ChannelPallete = .default) throws -> QRReader.DataAndQuad {
      let qrLayers: [CIImage] = Splitter.split(rgbaRep: rgbaRep, pallete: pallete)
      let dataAndQuads = qrLayers.compactMap { // concurrentCompactMap
         try? QRReader.dataAndQuad(ciImage: $0)
      }
      guard dataAndQuads.count == qrLayers.count else { throw NSError("Unable to read QR Layer") }
      let data: Data = .combine(data: dataAndQuads.map { $0.qrData })
      return (data, dataAndQuads[0].quad)
   }
}
/**
 * Image -> Data
 */
extension Reader {
   /**
    * Image -> Data (⚠️️ New ⚠️️)
    * - Needed for quick tests etc
    */
   public static func data(image: Image, pallete: ChannelPallete = .default) throws -> QRReader.DataAndQuad {
      let rgbaRep: RGBARep = try RGBARepUtil.rgbaRep(image: image)
      return try Reader.data(rgbaRep: rgbaRep, pallete: pallete)
   }
   /**
    * Image -> Data (⚠️️ New ⚠️️)
    * - Needed for quick tests etc
    */
   public static func data(image: Image, pallete: ChannelPallete = .default, onComplete: @escaping (_ data: Data?) -> Void) {
      guard let rgbaRep: RGBARep = try? RGBARepUtil.rgbaRep(image: image) else { Swift.print("err getting rgbImage"); return } // CVImageBufferUtil.rgbaRep(image: image)
      Reader.data(rgbaRep: rgbaRep, pallete: pallete) { (result: Reader.ReadResult2) in // Split the hccqrImg
         guard let value = try? result.get() else { onComplete(nil); return }
         onComplete(value.data)
      }
   }
}
