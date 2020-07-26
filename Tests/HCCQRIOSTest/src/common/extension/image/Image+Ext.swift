import Foundation
import QuartzCore
import CoreImage
//import HCCQR_lib
@testable import HCCQR_lib
/**
 * Asserter
 */
extension Image {
   /**
    * Compare images
    * - Parameter image: the image to assert against
    */
   public func isEqualToImage(image: Image) -> Bool {
      self.pngData() == image.pngData()
   }
}
