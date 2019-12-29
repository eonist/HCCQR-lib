import Foundation
import CoreImage
/**
 * Type
 */
extension Colorizer {
   typealias ColorMap = [ColorMapItem]
   /**
    * - Parameter idx: The array represents the layers of QRImages (true equals black, false equals white)
    */
   // 🏀
   // Fixme: ⚠️️ Use RGBColor with UInt8 instead of color, lots of conversion is not needed
   typealias ColorMapItem = (idx: [Bool], color: PixelData.RGBColor)
   /**
    * Used for colorizing CIImages
    */
   typealias ColorizedResult = Result<CIImage, Error>
}
