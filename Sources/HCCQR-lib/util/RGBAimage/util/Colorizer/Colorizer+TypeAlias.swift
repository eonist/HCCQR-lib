import Foundation
import CoreImage
/**
 * Type
 */
extension Colorizer {
   /**
    * 
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
