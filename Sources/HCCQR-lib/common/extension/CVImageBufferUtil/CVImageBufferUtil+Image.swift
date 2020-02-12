import AVFoundation
import QuartzCore
import CoreImage
/**
 * Image
 */
extension CVImageBufferUtil {
   /**
    * CVImageBuffer -> UIImage
    * - Important: ⚠️️ This methd exists for testing purpouses, the real code derives the buffer directly
    * - Parameter imageBuffer: Convert buffer to image
    */
   public static func image(imageBuffer: CVImageBuffer) -> Image {
      let ciImage: CIImage = .init(cvImageBuffer: imageBuffer)
      return Image(ciImage: ciImage)
   }
}
