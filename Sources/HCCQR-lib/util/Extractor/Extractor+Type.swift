import Foundation
/**
 * Completion type
 */
extension Extractor {
   /**
    * Returns the luminocity of each Color as a Grayscale representation
    * - Note: color-pallete's determines their similarity by comparing these r,g,b values
    * - Note: we keep the this as a typealias, we might want to pass errors, and debug info with the payload in the future
    * - Fixme: ⚠️️ rename to GrayReps?, move to global scope
    */
   typealias OnExtractionComplete = (GrayReps) -> Void
}
/**
 * Assert
 */
extension Extractor {
   /**
    * Output pixel similarity
    * - Parameter pixel: the input pixel
    * - Fixme: ⚠️️ move somewhere else?
    */
   typealias PixelSimilarity = (_ pixel: Pixel) -> Pixel.Similarity
}
