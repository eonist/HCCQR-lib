import AVFoundation
import QuartzCore
import CoreImage
/**
 * Image
 */
extension BufferUtil {
   /**
    * CVImageBuffer -> UIImage
    * - Important: ⚠️️ This methd exists for testing/debugging purpouses, the real code derives the buffer directly
    * - Parameters:
    *   - imageBuffer: Convert buffer to image
    *   - scale: the amount to scale the image by (screenScale)
    */
   public static func image(imageBuffer: CVImageBuffer, scale: Int) -> Image {
      let ciImage: CIImage = .init(cvImageBuffer: imageBuffer)
      return ImageUtil.image(ciImage: ciImage, scale: CGFloat(scale))
   }
}
