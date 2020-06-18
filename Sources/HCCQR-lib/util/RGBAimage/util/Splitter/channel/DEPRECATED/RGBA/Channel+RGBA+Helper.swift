import Foundation
/**
 * Private static helper methods
 */
extension Channel {
   /**
    * ⚠️️⚠️️⚠️️ DEPRECATED ⚠️️⚠️️⚠️️
    * Gets r, g, b channels
    * - Note: Marks red colors as black, all else becomes white
    * - Note: there is no speed benefit of writing the new pixeldata into a new rgba image, this was tested
    */
   static func channel(rgbaImg: RGBAImage, assert: PixelDataAssertion) -> RGBAImage {
      let blankImg = RGBAImage.rgbaImage(capacity: rgbaImg.capacity, size: rgbaImg.size) // We create a blank RGBImage, as it's faster than copy probably
      return rgbaImg.process(input: blankImg) { pixel -> Pixel in
         assert(pixel) ? Pixel.Colors.whitePixel : Pixel.Colors.blackPixel
      }
   }
}
