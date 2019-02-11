import UIKit
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
   internal static func colorize(pixels:[PixelData], colorMap:ColorMap) -> PixelData?{
      let findColor:(ColorMapItem) -> Bool = { colorMapItem in
         if colorMapItem.idx.count != pixels.count {Swift.print("Colorize.colorize - colorMap does not match pixel layer count");return false}
         let condition:(_ i:Int,_ pixel:PixelData) -> Bool = { (i:Int,pixel:PixelData) in
            let bothAreBlack:Bool = pixel.isBlack == (colorMapItem.idx[i] == 0)/*zero means black*/
            let bothAreWhite:Bool = pixel.isWhite == (colorMapItem.idx[i] == 1)/*zero means white*/
            if (bothAreBlack == false && bothAreWhite == false) {return false}//<- Sort of crazy looking, but it works 🤷
            else {return true}
         }
         return (pixels.enumerated().first(where: condition) == nil)
      }
      guard let color:UIColor = colorMap.first(where: findColor)?.color else {Swift.print("Unable to colorize");return nil}
      return PixelData.init(uiColor:color)
   }
   /**
    * Converts b&w RGBAImages into one color RGBAImage (on the basis of a colorMap rule-set)
    * - TODO: ⚠️️ Could be fater to just mutate the pixels diretly in an RGBAImage isntead of creating an pixel array like it is now?
    */
   internal static func colorize(rgbaImages:[RGBAImage], colorMap:ColorMap, scale:Int) -> RGBAImage?{
      guard let firstImage:RGBAImage = rgbaImages.first else {Swift.print("must contain at least one image");return nil}
      let pixels:[PixelData] = (0..<firstImage.height).indices.flatMap { y in /*flatMap Covert the 2-dim array to a 1-dim array*/
         return (0..<firstImage.width).indices.compactMap { x in
            let pixels:[PixelData] = rgbaImages.map{ $0.getPixelUnChecked(x:x,y:y) }
            guard let pixel:PixelData = colorize(pixels:pixels, colorMap:colorMap) else {Swift.print("⚠️️ unable to make pixel ⚠️️");return nil}
            return pixel
         }
      }
      /*Check if array has all the pixels*/
      guard pixels.count == Int(firstImage.width * firstImage.height) else {Swift.print("missing some pixels");return nil}
      return RGBAImage.rgbaImage(pixels: pixels, size:(width: firstImage.width, height: firstImage.height),scale:scale)
   }
}
