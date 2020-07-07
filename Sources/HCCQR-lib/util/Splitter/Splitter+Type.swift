import Foundation
import CoreImage
/**
 * Completion Type
 */
extension Splitter {
   /**
    * Contains two QR-images which is the result of 4-color split (R,G,B,(W/B))
    * - Note: when added to an UIImage, you need to set scale to 2.0 and orientation to .up
    * - Note: we pass on the colorChannels for debugging. should remove this in the future
    * - Parameters:
    *   - qrImgs: the QR images that was extracted from the HCCQR image
    *   - colorChannels: represents each channel defined by the ChannelPallete (The channels that was extracted from the hccqr)
    */
   public typealias SplitPayload = (qrImgs: [CIImage], colorChannels: GrayReps)
   /**
    * CIImgPair and SplitError
    */
   public typealias SplitResult = Result<SplitPayload, SplitError>
   /**
    * Completion handler for the split method
    */
   public typealias SplitComplete = (SplitResult) -> Void
}
