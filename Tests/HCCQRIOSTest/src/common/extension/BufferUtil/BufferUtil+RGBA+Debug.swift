import AVFoundation
import QuartzCore
import CoreImage
/**
 * For testing only (May be deprecated soon)
 */
extension BufferUtil {
   /**
    * Image -> RGBAImage (Not working)
    * - Fixme: ⚠️️ Add Image typealias in this repo??
    * - Note: this method works when testing img -> RGBA img -> img in viewcontroll, to see if everything looks gd etc, or do img.hash = img.hash etc
    * - Note: this method is for testing only because we derive RGBAImage directly from CVImageBuffer
    * - Note: RGBARep.rgbaRep(image:) has similar functionalir
    * - Parameter image: Convert image to RGBAImage
    */
   public static func rgbaRep(image: Image) throws -> RGBARep {
      let imgBuffer: CVImageBuffer = try imageBuffer(image: image)
      let bufferRect: BufferRect = CVImageBufferGetDisplayRect(imageBuffer: imgBuffer) // We have to provide the area we want to get data from
      return try rgbaRep(imageBuffer: imgBuffer, crop: bufferRect) /*, size: image.size, scale: image.scale*/
   }
}
