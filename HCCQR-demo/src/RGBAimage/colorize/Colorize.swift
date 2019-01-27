import UIKit
/**
 * Converts b&w layers into color layers
 */
class Colorize {
   typealias PixelGrid = [[Pixel]]
   /**
    * Converts b&w views to color view
    */
   static func colorize(views:[UIView],colorMap:ColorMap) -> UIImageView{
      let images:[UIImage] = views.map{$0.snapShot!}// TODO: ⚠️️ fatal error if unable to convert
      Swift.print("images.first?.size:  \(images.first?.size)")
      Swift.print("images.first?.scale:  \(images.first?.scale)")
      Swift.print("color for pos:  \(images.first?.getPixelColor(pos: .init(x: 160, y: 0)))")
      let image:UIImage = colorize(images: images, colorMap: colorMap)
//      Swift.print("image:  \(image)")
      let imageView:UIImageView = .init(image: image)
      return imageView
   }
   /**
    * Converts b&w images to color image
    */
   private static func colorize(images:[UIImage],colorMap:ColorMap) -> UIImage{
      let rgbaImages:[RGBAImage] = images.map{RGBAImage.init(img: $0)}// TODO: ⚠️️ fatal error if unable to convert
      let result:RGBAImage = colorize(images: rgbaImages, colorMap: colorMap)
      guard let image:UIImage = RGBAImage.image(rgbaImage: result) else {fatalError("unable to convert to UIImage")}
      return image
   }
   /**
    * Converts b&w RGBAImages into one color RGBAImage (on the basis of a colorMap rule-set)
    */
   private static func colorize(images:[RGBAImage], colorMap:ColorMap) -> RGBAImage{
      guard let firstImage:RGBAImage = images.first else {fatalError("must contain at least one image")}
      Swift.print("firstImage.width:  \(firstImage.width)")
      Swift.print("firstImage.height:  \(firstImage.height)")
      let pixels:[Pixel] = (0..<firstImage.width).indices.flatMap { x in /*flatMap Covert the 2-dim array to a 1-dim array*/
         return (0..<firstImage.height).indices.map { y in
            let pixels:[Pixel] = images.map{ image in
               return image.getPixel(x:x,y:y)!//TODO: ⚠️️ do error or something here
            }
//            if (x == 150 && y == 0) {
//               pixels.first?.debug()
//               pixels.last?.debug()
//            }
            return colorize(pixels:pixels,colorMap:colorMap)
         }
      }
      return .init(pixels: pixels, width: firstImage.width, height: firstImage.height)
   }
}
/**
 * Helper
 */
extension Colorize{
   /**
    * Converts a series of b&w pixels into one color pixel (on the basis of a colorMap rule set)
    * ## Examples:
    * colorize(pixels:[blackPixel,whitePixel]) -> RedPixel
    * colorize(pixels:[whitePixel,whitePixel]) -> BluePixel
    */
   fileprivate static func colorize(pixels:[Pixel], colorMap:ColorMap) -> Pixel{
      let findColor:(ColorMapItem) -> Bool = { colorMapItem in
         if colorMapItem.idx.count != pixels.count {fatalError("colorMap does not match pixel layer count")}
         for (i,pixel) in pixels.enumerated() {
            let bothAreBlack:Bool = pixel.isBlack == (colorMapItem.idx[i] == 0)/*zero means black*/
            let bothAreWhite:Bool = pixel.isWhite == (colorMapItem.idx[i] == 1)/*zero means white*/
            if (bothAreBlack == false && bothAreWhite == false) {return false}//<- Sort of crazy looking, but it works 🤷
         }
         return true
      }
      guard let color:UIColor = colorMap.first(where: findColor)?.color else {fatalError("Unable to colorize")}
      return .init(color:color)
   }
}
/**
 * ColorMap
 */
extension Colorize{
   typealias ColorMap = [ColorMapItem]
   typealias ColorMapItem = (idx:[Int],color:UIColor)
   /**
    * ColorMap
    * - TODO: ⚠️️ since index is unique we can make this hashable 👌 (it will be faster probably)
    */
   static let colorMap:ColorMap = {
      return [
         (idx:[0,1],UIColor.red),
         (idx:[1,0],UIColor.green),
         (idx:[1,1],UIColor.blue),
         (idx:[0,0],UIColor.white)
      ]
   }()
}
