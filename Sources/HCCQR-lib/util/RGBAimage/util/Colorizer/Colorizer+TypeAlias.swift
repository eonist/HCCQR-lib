import Foundation
/**
 * Type
 */
extension Colorizer {
   internal typealias ColorMap = [ColorMapItem]
   /**
    * - Parameter idx: The array represents the layers of QRImages (true equals black, false equals white)
    */
   internal typealias ColorMapItem = (idx: [Bool], color: Color)
}
