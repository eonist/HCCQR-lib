import UIKit
/**
 * Converts b&w layers into color layers
 */
class Colorize {
   typealias PixelGrid = [[Pixel]]
   /**
    * Converts b&w views to color view
    */
   static func colorize(views:[UIView],colorMap:ColorMap) -> UIImageView?{
      let images:[UIImage] = views.map{$0.snapShot!}// TODO: ⚠️️ fatal error if unable to convert
      Swift.print("images.first?.size:  \(String(describing: images.first?.size))")
      Swift.print("images.first?.scale:  \(String(describing: images.first?.scale))")
//      Swift.print("color for pos:  \(String(describing: images.first?.getPixelColor(pos: .init(x: 160, y: 0))))")
      guard let image:UIImage = colorize(images: images, colorMap: colorMap) else {Swift.print("unable to create colorize image");return nil}
//      Swift.print("image:  \(image)")
      let imageView:UIImageView = .init(image: image)
      return imageView
   }
   /**
    * Converts multiple b&w images to color image based on the colorMap provided
    */
   static func colorize(images:[UIImage], colorMap:ColorMap) -> UIImage? {
      let rgbaImages:[RGBAImage] = images.compactMap{RGBAImage.init(img: $0)}// TODO: ⚠️️ fatal error if unable to convert
      guard images.count == rgbaImages.count else {Swift.print("some rgbaImages was not created");return nil}
      guard let result:RGBAImage = colorize(rgbaImages: rgbaImages, colorMap: colorMap) else {Swift.print("unable to create colorized rgbaImage");return nil}
      guard let image:UIImage = RGBAImage.uiImage(rgbaImage: result,resultScale:1) else {Swift.print("unable to convert to UIImage");return nil}
      return image
   }
   /**
    * Converts b&w RGBAImages into one color RGBAImage (on the basis of a colorMap rule-set)
    */
   private static func colorize(rgbaImages:[RGBAImage], colorMap:ColorMap) -> RGBAImage?{
      guard let firstImage:RGBAImage = rgbaImages.first else {Swift.print("must contain at least one image");return nil}
      Swift.print("firstImage.width:  \(firstImage.width) height:  \(firstImage.height)")
      let pixels:[Pixel] = (0..<firstImage.height).indices.flatMap { y in /*flatMap Covert the 2-dim array to a 1-dim array*/
         return (0..<firstImage.width).indices.compactMap { x in
            let pixels:[Pixel] = rgbaImages.compactMap{ image in
               guard let pixel = image.getPixel(x:x,y:y) else {Swift.print("⚠️️ unable to get pixel ⚠️️");return nil}
               return pixel
            }
            //if (x == 150 && y == 0) {pixels.first?.debug();pixels.last?.debug() }
            guard let pixel:Pixel = colorize(pixels:pixels, colorMap:colorMap) else {Swift.print("⚠️️ unable to make pixel ⚠️️");return nil}
            return pixel
         }
      }
      guard pixels.count == Int(firstImage.width * firstImage.height) else {Swift.print("missing some pixels");return nil}
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
    * TODO: ⚠️️ Somehow replace the fatalError with throw?
    */
   fileprivate static func colorize(pixels:[Pixel], colorMap:ColorMap) -> Pixel?{
      let findColor:(ColorMapItem) -> Bool = { colorMapItem in
         if colorMapItem.idx.count != pixels.count {fatalError("colorMap does not match pixel layer count")}
         for (i,pixel) in pixels.enumerated() {
            let bothAreBlack:Bool = pixel.isBlack == (colorMapItem.idx[i] == 0)/*zero means black*/
            let bothAreWhite:Bool = pixel.isWhite == (colorMapItem.idx[i] == 1)/*zero means white*/
            if (bothAreBlack == false && bothAreWhite == false) {return false}//<- Sort of crazy looking, but it works 🤷
         }
         return true
      }
      guard let color:UIColor = colorMap.first(where: findColor)?.color else {Swift.print("Unable to colorize");return nil}
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
    * ColorMap (standard 4 color ColorMap)
    * - TODO: ⚠️️ since index is unique we can make this hashable 👌 (it will be faster probably), caseIteratable 👈
    */
   static let colorMap:ColorMap = {
      return [
         (idx:[0,1],UIColor.red),//black,white
         (idx:[1,0],UIColor.green),//white,black
         (idx:[1,1],UIColor.blue),//black,black
         (idx:[0,0],UIColor.white)//white,white
      ]
   }()
   /**
    * blandColorMap
    */
   static let blandColorMap:ColorMap = {
      return [
         (idx:[0,1],UIColor.init(red: 0.8, green: 0.2, blue: 0.2, alpha: 1)),//black,white
         (idx:[1,0],UIColor.init(red: 0.2, green: 0.8, blue: 0.2, alpha: 1)),//white,black
         (idx:[1,1],UIColor.init(red: 0.2, green: 0.2, blue: 0.8, alpha: 1)),//black,black
         (idx:[0,0],UIColor.init(red: 0.8, green: 0.8, blue: 0.8, alpha: 1))//white,white
      ]
   }()
}
