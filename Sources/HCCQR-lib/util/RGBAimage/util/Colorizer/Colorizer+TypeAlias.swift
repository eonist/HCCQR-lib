import Foundation
import CoreImage
/**
 * Type
 */
extension Colorizer {
   /**
    * idx represent false = black, true = white, if you match the array correctly, then the color is used
    */
   typealias ColorMap = [ColorMapItem]
   /**
    * - Parameter idx: The array represents the layers of QRImages (true equals black, false equals white)
    */
   typealias ColorMapItem = (idx: [Bool], color: PixelData.RGBColor)
   /**
    * Used for colorizing CIImages
    */
   typealias ColorizedResult = Result<CIImage, Error>
}
