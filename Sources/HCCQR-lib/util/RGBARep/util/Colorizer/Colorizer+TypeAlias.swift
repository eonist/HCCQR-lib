import Foundation
import CoreImage
/**
 * Type
 */
extension Colorizer {
   /**
    * The idea is that ColorMap array can hold 4-colors, 8-colors, 16-colors etc
    * - Note: idx represent false = black, true = white
    * - Note: if you match the array correctly, then the color is used
    */
   public typealias ColorMap = [ColorMapItem]
   /**
    * - Parameters:
    *   - idx: The array represents the layers of QRImages (true equals black, false equals white)
    *   - color: the color at the index
    */
   public typealias ColorMapItem = (idx: [Bool], color: Pixel)
   /**
    * Used for colorizing CIImages
    */
   typealias ColorizedResult = Result<CIImage, ColorizeError>
}
/**
 * Helper
 */
extension Array where Element == Colorizer.ColorMapItem {
   var layerCount: Int {
      Int(Algebra.exponent(base: 2, value: CGFloat(self.count)))
   }
}
