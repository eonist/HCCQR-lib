import Foundation
/**
 * Converts b&w layers into color layers
 */
internal class Colorize {
   /**
    * Converts multiple b&w images to color image based on the colorMap provided
    * - TODO: ⚠️️ pass cgImages istead of uiimages, it might be faster
    * - Parameter moduleMultiplier: This is the multiplier. ModuleCount equals 1 pixel. ModuleCount for QRVersion 10 is 57 not counting 2 for margins. So (57+2)*6 = 354, if you want 2xretina its 354 * 2 = 708
    * - Parameter images: b&w QRImages
    * - Parameter colorMap: the color depth you want the HCCQR image in. 4,8,16,32 etc
    * - Parameter scale: for retina you need 2x scale etc
    */
   internal static func colorize(images:[Image], colorMap:ColorMap, moduleMultiplier:Int, scale:Int) -> Image? {
      let rgbaImages:[RGBAImage] = images.compactMap{RGBAImage.rgbaImage(image: $0)}
      guard images.count == rgbaImages.count else {Swift.print("Colorize.colorize() - some rgbaImages was not created");return nil}
      guard let result:RGBAImage = colorize(rgbaImages: rgbaImages, colorMap: colorMap, moduleMultiplier:moduleMultiplier,scale:scale) else {Swift.print("Colorize.colorize() - Unable to create colorized rgbaImage");return UIImage()}
      guard let image:Image = RGBAImage.image(rgbaImage: result, scale:CGFloat(scale)) else {Swift.print("Colorize.colorize() - Unable to convert to UIImage");return nil}
      result.pixels.deallocate()/*⚠️️⚠️️We get a mem leak in iOS if we dont deallocate the pixels⚠️️⚠️️*/
      return image
   }
}
