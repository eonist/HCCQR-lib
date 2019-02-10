import UIKit
/**
 * Converts b&w layers into color layers
 */
class Colorize {
   
//   typealias PixelGrid = [[PixelData]]
   /**
    * Converts multiple b&w images to color image based on the colorMap provided
    */
   static func colorize(images:[UIImage], colorMap:ColorMap, scale:Int) -> UIImage? {
      let rgbaImages:[RGBAImage] = images.compactMap{RGBAImage.rgbaImage(image: $0)}
      guard images.count == rgbaImages.count else {Swift.print("Colorize.colorize() - some rgbaImages was not created");return nil}
      guard let result:RGBAImage = colorize(rgbaImages: rgbaImages, colorMap: colorMap, scale:scale) else {Swift.print("Colorize.colorize() - Unable to create colorized rgbaImage");return nil}
      guard let image:UIImage = RGBAImage.uiImage(rgbaImage: result, resultScale:1) else {Swift.print("Colorize.colorize() - Unable to convert to UIImage");return nil}
      return image
   }
}
/**
 * Convenience
 */
extension Colorize{
   /**
    * Converts two b&w-views to one color-view
    */
   static func colorize(views:[UIView],colorMap:ColorMap, scale:Int) -> UIImageView?{
      let images:[UIImage] = views.map{$0.snapShot!}// TODO: ⚠️️ fatal error if unable to convert
      //      Swift.print("images.first?.size:  \(String(describing: images.first?.size))")
      //      Swift.print("images.first?.scale:  \(String(describing: images.first?.scale))")
      //      Swift.print("color for pos:  \(String(describing: images.first?.getPixelColor(pos: .init(x: 160, y: 0))))")
      guard let image:UIImage = colorize(images:images, colorMap:colorMap, scale:scale) else {Swift.print("unable to create colorize image");return nil}
      //      Swift.print("image:  \(image)")
      let imageView:UIImageView = .init(image: image)
      return imageView
   }
}
