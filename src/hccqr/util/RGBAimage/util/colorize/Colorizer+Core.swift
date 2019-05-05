import Foundation
/**
 * Core
 */
extension Colorizer {
   /**
    * Converts b&w RGBAImages into one color RGBAImage (on the basis of a colorMap rule-set)
    * - Fixme: ⚠️️ Could be faster to just mutate the pixels diretly in an RGBAImage instead of creating an pixel array like it is now?
    * - Parameter scale: for retina you need 2x scale etc
    */
   internal static func colorize(rgbaImages: [RGBAImage], colorMap: ColorMap, moduleMultiplier: Int, scale: Int) -> RGBAImage? {
      guard let size = rgbaImages.first?.size else { Swift.print("must contain at least one image"); return nil }/*The first image is used for getting size etx*/
      let pixels: [PixelData] = (0..<size.height).indices.flatMap { y in /*flatMap Covert the 2-dim array to a 1-dim array*/
         return (0..<size.width).indices.compactMap { x in
            let pixels: [PixelData] = rgbaImages.map { $0.getPixel(x: x, y: y) }/*Overlaying pixels*/
            guard let pixel: PixelData = colorize(pixels: pixels, colorMap: colorMap) else { Swift.print("⚠️️ unable to make pixel ⚠️️"); return nil }
            return pixel
         }
      }
      rgbaImages.forEach { $0.deinitiate() }/*Avoids mem leak*/
      guard pixels.count == size.width * size.height else { Swift.print("missing some pixels"); return nil }/*Check if array has all the pixels*/
      let multiplier: Int = moduleMultiplier * scale /*Support for retina resolutions*/
      return RGBAImage.rgbaImage(pixels: pixels, size: (size.width, size.height), moduleMultiplier: multiplier)
   }
}
/**
 * Helper
 */
extension Colorizer {
   /**
    * Converts a series of b&w pixels into one color pixel (on the basis of a colorMap rule set)
    * ## Examples:
    * colorize(pixels:[blackPixel,whitePixel]) -> RedPixel
    * colorize(pixels:[whitePixel,whitePixel]) -> BluePixel
    */
   private static func colorize(pixels: [PixelData], colorMap: ColorMap) -> PixelData? {
      let findColor: (ColorMapItem) -> Bool = { colorMapItem in
         if colorMapItem.idx.count != pixels.count { Swift.print("Colorize.colorize - colorMap does not match pixel layer count"); return false }
         let condition: (_ i: Int, _ pixel: PixelData) -> Bool = { (i: Int, pixel: PixelData) in
            let bothAreBlack: Bool = pixel.isBlack == (colorMapItem.idx[i] == 0)/*zero means black*/
            let bothAreWhite: Bool = pixel.isWhite == (colorMapItem.idx[i] == 1)/*zero means white*/
            if bothAreBlack == false && bothAreWhite == false { return false }//<- Sort of crazy looking, but it works 🤷
            else { return true }
         }
         return (pixels.enumerated().first(where: condition) == nil)
      }
      guard let color: Color = colorMap.first(where: findColor)?.color else { Swift.print("Unable to colorize"); return nil }
      return PixelData(uiColor: color)
   }
}
