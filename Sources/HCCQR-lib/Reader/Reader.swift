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
    * CVImageBuffer -> Data (⚠️️ New, UNTESTED ⚠️️)
    * - Parameters:
    *   - imageBuffer: The buffer containing the raw pixel data and size
    *   - crop: Makes processing the raw imagery faster since we don't have to process areas where the QR info is not etc.
    */
   public static func data(imageBuffer: CVImageBuffer, crop: BufferRect, pallete: ChannelPallete = .default) throws -> ReadPayload {
      guard let rgbaImg: RGBARep = try? BufferUtil.rgbaRep(imageBuffer: imageBuffer, crop: crop) else { throw ReadError.unableToExtractRGBAImageFromCVBuffer }
      guard let dataAndImagesAndQuad: QRReader.DataAndQuad = try? data(rgbaRep: rgbaImg, pallete: pallete) else { throw ReadError.unableToGetDataAndImages(msg: "err") }
      let data: Data = dataAndImagesAndQuad.qrData
      let quad: QRReader.Quad = dataAndImagesAndQuad.quad // else { throw ReadError.unableToGetDataOrQuad }
      let dataAndMeta: ReadPayload = (data: data, quad: quad, imageSize: rgbaImg.cgSize)
      return dataAndMeta
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
      // the concurrentCompactMap is experimental, works for now
      let dataAndQuads: [QRReader.DataAndQuad] = /*try*/ qrLayers.concurrentCompactMap { // concurrentCompactMap
         do {
            return try QRReader.dataAndQuad(ciImage: $0)
         } catch {
            Swift.print("⚠️️ error ⚠️️ :  \(error)")
            return nil
         }
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
    * - Note: Needed for quick tests etc
    */
   public static func data(image: Image, pallete: ChannelPallete = .default, onComplete: @escaping (_ data: Data?) -> Void) {
      guard let rgbaRep: RGBARep = try? RGBARepUtil.rgbaRep(image: image) else { Swift.print("err getting rgbImage"); return } // CVImageBufferUtil.rgbaRep(image: image)
      Reader.data(rgbaRep: rgbaRep, pallete: pallete) { (result: Reader.ReadResult2) in // Split the hccqrImg
         guard let value = try? result.get() else { onComplete(nil); return }
         onComplete(value.data)
      }
   }
}
