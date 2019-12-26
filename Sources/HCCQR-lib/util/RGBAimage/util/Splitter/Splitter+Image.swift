import Foundation
import ResultSugar
/**
 * Utils
 * - Fixme: ⚠️️ Maybe rename to RGBAImageSplitter
 */
extension Splitter {
   /**
    * Returns channels (rgb for now) (3 channels, red, green, blue)
    */
   static func channels(image: Image, onComplete:@escaping OnChannelsCompleted) {
      guard let rgbaImg: RGBAImage = try? .rgbaImage(image: image) else { onComplete(.failure(NSError("Unable to create rgbaImg"))); return }
      channels(rgbaImg: rgbaImg, onComplete: onComplete)
   }
}
