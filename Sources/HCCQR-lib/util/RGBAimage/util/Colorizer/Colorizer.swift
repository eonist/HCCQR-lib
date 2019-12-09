import Foundation
import QuartzCore
/**
 * Converts b&w layers into color layers
 */
internal class Colorizer {
   /**
    * Converts multiple b&w images to color image based on the colorMap provided
    * - Fixme: ⚠️️ pass cgImages istead of uiimages, it might be faster
    * - Parameters:
    *    - images: b&w QRImages
    *    - colorMap: the color depth you want the HCCQR image in. 4, 8, 16, 32 etc
    *    - multipliers: modulescale and screenScale, for retina you need 2x scale etc, This is the multiplier. ModuleCount equals 1 pixel. ModuleCount for QRVersion 10 is 57 not counting 2 for margins. So (57+2)*6 = 354, if you want 2xretina its 354 * 2 = 708
    */
   internal static func colorize(images: [Image], colorMap: ColorMap, multipliers: Multipliers) throws -> Image {
      let rgbaImages: [RGBAImage] = images.compactMap { try? RGBAImage.rgbaImage(image: $0) }
      guard images.count == rgbaImages.count else { throw "Colorize.colorize() - some rgbaImages was not created" /*Swift.print();return nil*/ }
      guard let result: RGBAImage = try? colorize(rgbaImages: rgbaImages, colorMap: colorMap, multipliers: multipliers) else { throw "Colorize.colorize() - Unable to create colorized rgbaImage" }
      guard let image: Image = try? RGBAImage.image(rgbaImage: result, scale: CGFloat(multipliers.screenScale)) else { throw "Colorize.colorize() - Unable to convert to UIImage"/*Swift.print();return nil*/ }
      result.deinitiate() // ⚠️️⚠️️ We get a mem leak in iOS if we don't deallocate the pixels ⚠️️⚠️️
      return image
   }
}
