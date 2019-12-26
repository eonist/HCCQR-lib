import Foundation
/**
 * Type
 */
extension Colorizer {
   internal typealias ColorMap = [ColorMapItem]
   /**
    * - Parameter idx: The array represents the layers of QRImages (true equals black, false equals white)
    */
   // 🏀
   // Fixme: ⚠️️ Use RGBColor with UInt8 instead of color, lots of conversion is not needed
   internal typealias ColorMapItem = (idx: [Bool], color: PixelData.RGBColor)
}
