import AVFoundation
import QuartzCore
import CoreImage
/**
 * Image
 */
extension CVImageBufferUtil {
   /**
    * CVImageBuffer -> UIImage
    */
   public static func image(imageBuffer: CVImageBuffer) -> Image {
      let ciImage: CIImage = .init(cvImageBuffer: imageBuffer)
      
      return Image(ciImage: ciImage)
   }
}
