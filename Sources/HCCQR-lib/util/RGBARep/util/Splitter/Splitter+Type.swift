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
//   typealias CIIMGPair = (qrImg1: CIImage, qrImg2: CIImage)
   public typealias SplitPayload = (qrImgs: [CIImage], rgbChannels: Channel.RGBChannels)
   /**
    * CIImgPair and SplitError
    */
   public typealias SplitResult = Result<SplitPayload, SplitError>
   /**
    * Completion handler for the split method
    */
   public typealias SplitComplete = (SplitResult) -> Void
}
/**
 * Used with composition process
 */
extension Splitter {
   /**
    * Used when compositing together 
    * - Fixme: ⚠️️ should prob use array when supporting more than 4 colors etc?, or is it always pairs?
    */
   typealias ChannelPair = (first: GrayscaleRep, second: GrayscaleRep)
}
