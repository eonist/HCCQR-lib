import Foundation
import QR_lib
import QuartzCore
import CoreImage
import ParallelLoop
import TimeMeasure
/**
 * Reads HCCQR into binary data
 */
public typealias HCCQRReader = Reader
public final class Reader {}

extension Reader {
   public typealias ReadPayload = (data: Data, quad: QRReader.Quad, imageSize: CGSize)
   /**
    * CVImageBuffer -> Data
    * - Note: Adds support for CVImageBuffer (For processing data from camera)
    * 1. Create RGBA representation of the CVImageBuffer
    * 2. Split the RGBA into multiple QR-Images
    * 3. Extract the data from the QR-Images
    * 4. Combine the multiple Data's into one Data
    * 5. Return the data and the meta-data
    * - Fixme: ⚠️️ rename imageBuffer to buffer
    * - Parameters:
    *   - imageBuffer: The buffer containing the raw pixel data and size
    *   - crop: Makes processing the raw imagery faster since we don't have to process areas where the QR info is not etc.
    *   - scheme: hccqr setup
    *   - parallel: for single capture, parallel is fast, for sequence, parallel is slower
    */
   public static func data(imageBuffer: CVImageBuffer, crop: BufferRect, scheme: ChannelScheme = .default, parallel: Bool) throws -> ReadPayload {
//      let crop = crop ?? CVImageBufferGetEncodedSize(imageBuffer) // CVImageBufferGetDisplaySize, CVImageBufferGetCleanRect
      let rgbaImg: RGBARep = try BufferUtil.rgbaRep(buffer: imageBuffer, crop: crop)
      let dataAndImagesAndQuad: QRReader.DataAndQuad = try data(rgbaRep: rgbaImg, scheme: scheme, parallel: parallel)
      let data: Data = dataAndImagesAndQuad.qrData
      let quad: QRReader.Quad = dataAndImagesAndQuad.quad
      return (data: data, quad: quad, imageSize: rgbaImg.cgSize)
   }
   /**
    * Image -> Data
    * - Needed for quick tests etc
    * - Parameters:
    *   - image: hccqr test
    *   - scheme: hccqr setup
    *   - parallel: for single capture, parallel is fast, for sequence, parallel is slower
    */
   public static func data(image: Image, scheme: ChannelScheme = .default, parallel: Bool) throws -> QRReader.DataAndQuad {
      let (rgbaRep, time): (RGBARep?, Double) = TimeMeasure.timeElapsed { // adds timeMeasure on this call, see if it taints the read benchamarking, if it does, use Buffer as testbed instead
         try? RGBARep.imageRep(image: image) // <- new ⚠️️
//         /*let rgbaRep: RGBARep = */try? RGBARepresentation.rgbaRepresentation(image: image) //
      }
      Log.log("Image to rgbaRep time:  \(time)")
      guard let _rgbaRep = rgbaRep else { throw NSError(domain: "err creating rgbaRep", code: 0) }
      return try data(rgbaRep: _rgbaRep, scheme: scheme, parallel: parallel)
   }
}
/**
 * Support for parallel reading of input
 */
extension Reader {
   /**
    * Reads rgbaRep, outputs Data
    * - Fixme: ⚠️️⚠️️⚠️️ Putting many calls to this method in a concurrent loop is very effective, possibly disable concurrancy within this call might speed up things even more? like a toggle
    * - Fixme: ⚠️️ the QRReader doesn't like to be processes parralelly, this needs confirmation with concurrent test
    * - Fixme: ⚠️️ When the first QRImage Quad is found, the subsequent QR-Rects will be in the same quadrant, clip the subsequent images, maybe if you do the parrallel computing in the sequence / streaming lib
    * - Abstract: Since we get pixel data from the camera, this will be faster than converting to image first
    * - Note: returning qrimage is useful, it is used as a way to debug that the HCCQR ws split correctly
    * - Note: Isn't private because Tests use it
    * - Parameters:
    *   - rgbaRep: raw pixels and size
    *   - scheme: the arrangment of colors
    *   - parallel: for single capture, parallel is fast, but for sequence parallel is slower
    */
   /*private*/ internal static func data(rgbaRep: RGBARep, scheme: ChannelScheme, parallel: Bool) throws -> QRReader.DataAndQuad {
      let qrLayers: [CIImage] = Splitter.split(rgbaRep: rgbaRep, scheme: scheme, parallel: parallel)
      let dataAndQuads: [QRReader.DataAndQuad] = qrLayers.concurrentCompactMap(parallel: parallel) { // concurrentCompactMap
         try? QRReader.dataAndQuad(ciImage: $0)
      }
      guard dataAndQuads.count == qrLayers.count else { throw NSError(domain: "Unable to read QR Layer", code: 0) }
      let data: Data = .combine(data: dataAndQuads.map { $0.qrData }) // merge the data together
      return (data, dataAndQuads[0].quad)
   }
}
