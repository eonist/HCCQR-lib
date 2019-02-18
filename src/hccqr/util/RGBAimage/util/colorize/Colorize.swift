import Foundation
/**
 * Converts b&w layers into color layers
 */
internal class Colorize {
   /**
    * Converts multiple b&w images to color image based on the colorMap provided
    * - TODO: ⚠️️ pass cgImages istead of uiimages, it might be faster
    * - Parameter scale: This is the multiplier. ModuleCount equals 1 pixel. ModuleCount for QRVersion 10 is 57 not counting 2 for margins. So (57+2)*6 = 354, if you want 2xretina its 354 * 2 = 708
    * - Parameter images: b&w QRImages
    * - PArameter colorMap: the color depth you want the HCCQR image in. 4,8,16,32 etc
    */
   internal static func colorize(images:[Image], colorMap:ColorMap, scale:Int) -> Image? {
      let rgbaImages:[RGBAImage] = images.compactMap{RGBAImage.rgbaImage(image: $0)}
      guard images.count == rgbaImages.count else {Swift.print("Colorize.colorize() - some rgbaImages was not created");return nil}
      guard let result:RGBAImage = colorize(rgbaImages: rgbaImages, colorMap: colorMap, scale:scale) else {Swift.print("Colorize.colorize() - Unable to create colorized rgbaImage");return nil}
      guard let image:Image = RGBAImage.uiImage(rgbaImage: result, resultScale:1) else {Swift.print("Colorize.colorize() - Unable to convert to UIImage");return nil}
      return image
   }
}
/**
 * Convenience
 */
//internal extension Colorize{
//   /**
//    * Converts two b&w-views to one color-view
//    */
//   internal static func colorize(views:[UIView],colorMap:ColorMap, scale:Int) -> UIImageView?{
//      let images:[UIImage] = views.map{$0.snapShot!}// TODO: ⚠️️ fatal error if unable to convert
//      //      Swift.print("images.first?.size:  \(String(describing: images.first?.size))")
//      //      Swift.print("images.first?.scale:  \(String(describing: images.first?.scale))")
//      //      Swift.print("color for pos:  \(String(describing: images.first?.getPixelColor(pos: .init(x: 160, y: 0))))")
//      guard let image:Image = colorize(images:images, colorMap:colorMap, scale:scale) else {Swift.print("unable to create colorize image");return nil}
//      //      Swift.print("image:  \(image)")
//      let imageView:UIImageView = .init(image: image)
//      return imageView
//   }
//}
