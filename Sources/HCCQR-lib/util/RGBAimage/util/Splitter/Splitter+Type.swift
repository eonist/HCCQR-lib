import Foundation
import CoreImage
/**
 * Completion Type
 */
extension Splitter {
   /**
    * Contains two QR-images which is the result of 4-color split (R,G,B,(W/B))
    * - Note: when added to an UIImage, you need to set scale to 2.0 and orientation to .up
    */
   typealias CIIMGPair = (qrImg1: CIImage, qrImg2: CIImage)
   /**
    * CIImgPair and SplitError
    */
   typealias Payload = Result<CIIMGPair, SplitError>
   /**
    * Completion handler for the split method
    */
   typealias Complete = (Payload) -> Void
}
/**
 * Used with composition process
 */
extension Splitter {
   /**
    * - Fixme: ⚠️️ should prob use array when supporting more than 4 colors etc?
    */
   typealias ChannelPair = (first: GrayscaleRep, second: GrayscaleRep)
}
