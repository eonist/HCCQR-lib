import AVFoundation
import QuartzCore
import CoreImage
/**
 * For testing only (May be deprecated soon)
 */
extension CVImageBufferUtil {
   /**
    * Image -> RGBAImage (Not working)
    * - Fixme: ⚠️️ Add Image typealias in this repo??
    * - Fixme: ⚠️️ Maybe test img -> RGBA img -> img in viewcontroll, to see if everything looks gd etc, or do img.hash = img.hash etc
    * - Note: this method is for testing only because we derive RGBAImage directly from CVImageBuffer
    * - Parameter image: Convert image to RGBAImage
    */
   public static func rgbaImage(image: Image) throws -> RGBAImage {
      let imgBuffer: CVImageBuffer = try imageBuffer(image: image)
      let bufferRect: BufferRect = CVImageBufferGetDisplayRect(imageBuffer: imgBuffer) // We have to provide the area we want to get data from
      return try rgbaImage(imageBuffer: imgBuffer, crop: bufferRect) /*, size: image.size, scale: image.scale*/
   }
}
