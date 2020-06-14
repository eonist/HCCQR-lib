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
   typealias ColorMap = [ColorMapItem]
   /**
    * - Parameter idx: The array represents the layers of QRImages (true equals black, false equals white)
    * - Parameter color: the color at the index
    */
   typealias ColorMapItem = (idx: [Bool], color: PixelData.RGBAColor)
   /**
    * Used for colorizing CIImages
    */
   typealias ColorizedResult = Result<CIImage, Error>
}
