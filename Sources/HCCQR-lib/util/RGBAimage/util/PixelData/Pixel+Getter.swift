import Foundation
/**
 * Getter
 */
extension Pixel {
   /**
    * Returns rgb
    * - Note: Used in the Asser methods
    */
   var rgb: Pixel.RGB { (r, g, b) }
   /**
    * - Note: Used by Pixel.isSimilar method
    */
   var rgba: Pixel.RGBAColor { (r, g, b, a) }
}
