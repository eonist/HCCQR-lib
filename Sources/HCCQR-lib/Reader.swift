import Foundation
import QR_lib
import QuartzCore
import CoreImage
import ParallelLoop
import TimeMeasure
/**
 * Reads HCCQR into binary data
 */
@available(*, deprecated, renamed: "HCCQRReader")
public typealias Reader = HCCQRReader
public final class HCCQRReader {}

extension HCCQRReader {
   /**
    * - Fixme: ⚠️️ Why are we including the imageSize?
    */
   public typealias ReadPayload = (data: Data, quad: QRReader.Quad, imageSize: CGSize)
   /**
    * CVImageBuffer -> Data
    * - Note: Adds support for CVImageBuffer (For processing data from camera)
    * 1. Create RGB representation of the CVImageBuffer
    * 2. Split the RGB into multiple QR-Images
    * 3. Extract the data from the QR-Images
    * 4. Combine the multiple Data's into one Data
    * 5. Return the data and the meta-data
    * - Fixme: ⚠️️ rename imageBuffer to buffer
    * - Fixme: ⚠️️ make crop optional?
    * - Parameters:
    *   - imageBuffer: The buffer containing the raw pixel data and size
    *   - crop: Makes processing the raw imagery faster since we don't have to process areas where the QR info is not etc.
    *   - scheme: hccqr setup
    *   - parallel: for single capture, parallel is fast, for sequence, parallel is slower
    */
   public static func data(imageBuffer: CVImageBuffer, crop: BufferRect, scheme: ChannelScheme = .default, parallel: Bool) throws -> ReadPayload {
//      let crop = crop ?? CVImageBufferGetEncodedSize(imageBuffer) // CVImageBufferGetDisplaySize, CVImageBufferGetCleanRect
      let rgbImg: RGBRep = try BufferUtil.rgbRep(buffer: imageBuffer, crop: crop)
      let dataAndImagesAndQuad: QRReader.DataAndQuad = try data(rgbRep: rgbImg, scheme: scheme, parallel: parallel)
      let data: Data = dataAndImagesAndQuad.qrData
      let quad: QRReader.Quad = dataAndImagesAndQuad.quad
      return (data: data, quad: quad, imageSize: rgbImg.cgSize)
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
      let (rgbRep, time): (RGBRep, Double) = try TimeMeasure.timeElapsed { // adds timeMeasure on this call, see if it taints the read benchamarking, if it does, use Buffer as testbed instead
         try RGBRep.imageRep(image: image)
      }
      Log.log("Image to rgbRep time:  \(time)")
      return try data(rgbRep: rgbRep, scheme: scheme, parallel: parallel)
   }
   /**
    * CGImage -> Data
    */
   public static func data(cgImage: CGImage, scheme: ChannelScheme = .default, parallel: Bool) throws -> QRReader.DataAndQuad {
      let rgbRep: RGBRep = try RGBRep.imageRep(cgImage: cgImage)
      return try data(rgbRep: rgbRep, scheme: scheme, parallel: parallel)
   }
}
/**
 * Support for parallel reading of input
 */
extension HCCQRReader {
   /**
    * Reads rgbRep, outputs Data
    * - Fixme: ⚠️️⚠️️⚠️️ Putting many calls to this method in a concurrent loop is very effective, possibly disable concurrancy within this call might speed up things even more? like a toggle
    * - Fixme: ⚠️️ When the first QRImage Quad is found, the subsequent QR-Rects will be in the same quadrant, clip the subsequent images, maybe if you do the parrallel computing in the sequence / streaming lib
    * - Fixme: ⚠️️ make proper error type
    * - Description: Since we get pixel data from the camera, this will be faster than converting to image first
    * - Note: returning qrimage is useful, it is used as a way to debug that the HCCQR ws split correctly
    * - Note: Isn't private because Tests use it
    * - Parameters:
    *   - rgbRep: raw pixels and size
    *   - scheme: the arrangment of colors
    *   - parallel: for single capture, parallel is fast, but for sequence parallel is slower
    */
   /*private*/ internal static func data(rgbRep: RGBRep, scheme: ChannelScheme, parallel: Bool) throws -> QRReader.DataAndQuad {
      let qrLayers: [CIImage] = Splitter.split(rgbRep: rgbRep, scheme: scheme, parallel: parallel)
      rgbRep.deallocate() // we have no more use for the rgbRep
      let dataAndQuads: [QRReader.DataAndQuad] = qrLayers.concurrentCompactMap(parallel: parallel) { // concurrentCompactMap
         try? QRReader.dataAndQuad(ciImage: $0)
      }
      guard dataAndQuads.count == qrLayers.count else { throw NSError(domain: "Unable to read QR Layer qrLayers.count: \(qrLayers.count) dataAndQuads.count: \(dataAndQuads.count)", code: 0) }
      let data: Data = dataAndQuads.map { $0.qrData }.combined // merge the data together
      return (data, dataAndQuads[0].quad)
   }
}
