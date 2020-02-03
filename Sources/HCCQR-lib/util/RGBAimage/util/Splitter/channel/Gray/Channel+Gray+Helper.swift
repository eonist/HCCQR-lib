import Foundation
/**
 * Helper
 */
extension Channel {
   /**
    * RGBAImage channel (r, g, b) -> GrayscaleImage
    * - Parameters:
    *   - rgbaImg: The RGBAImage to manipulate
    *   - assert: takes Pixeldata, returns Bool
    */
   static func grayChannel(rgbaImg: RGBAImage, assert: PixelDataAssertion) -> GrayscaleImage {
      let blankImg: GrayscaleImage = .grayscaleImage(capacity: rgbaImg.capacity, size: rgbaImg.size) // We create a blank RGBImage, as it's faster than copy probably
      return GrayscaleImage.process(input: rgbaImg, output: blankImg) { pixel -> UInt8 in
         assert(pixel) ? .white : .black // Asserts if pixel matches the pixel-data-assert method, if it does return white
      }
   }
}
