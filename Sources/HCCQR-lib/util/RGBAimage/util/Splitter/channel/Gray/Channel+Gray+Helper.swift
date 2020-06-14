import Foundation
/**
 * Helper
 */
extension Channel {
   /**
    * RGBAImage channel (R, G, B) -> GrayscaleImage
    * 1. Creates a blank grayscale image of a specific size
    * 2. Asserts if the pixel is sort of a color or not
    * - Parameters:
    *   - rgbaImg: The RGBAImage to manipulate
    *   - assert: takes Pixeldata, returns Bool
    */
   static func grayChannel(rgbaImg: RGBAImage, asserter: PixelDataSimilarity) -> GrayscaleImage {
      let blankImg: GrayscaleImage = .grayscaleImage(capacity: rgbaImg.capacity, size: rgbaImg.size) // We create a blank RGBImage, as it's faster than copy probably
      return GrayscaleImage.process(input: rgbaImg, output: blankImg) { pixel -> UInt8 in
//         Swift.print("⚠️️ bug here? ⚠️️")
         // fixme: ⚠️️ This is the bug, we should rather use the degree of gray, solved now
         let intensity = asserter(pixel).strength // more strength, more white
//         Swift.print("intensity:  \(intensity)")
         return intensity
      }
   }
}
