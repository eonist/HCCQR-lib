import Foundation
/**
 * PixelSimilarity
 */
extension Extractor {
   /**
    * Output pixel similarity
    * - Note: color-pallete's determines their similarity by comparing these r,g,b values
    * - Parameter pixel: the input pixel
    */
   typealias PixelSimilarity = (_ pixel: Pixel) -> Pixel.Similarity
}
