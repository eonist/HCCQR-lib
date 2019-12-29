import Foundation
import QuartzCore
import CoreImage

extension Colorizer {
   /**
    * ciImages -> CIImage
    * - Note: We get CIImages because thats what QR produces
    * - Note: Used in the process of converting Data to HCCQR
    */
   static func colorize(ciImages: [CIImage], colorMap: ColorMap, multipliers: Multipliers) -> ColorizedResult {
      let rgbaImages: [RGBAImage] = ciImages.compactMap { try? RGBAImage.rgbaImage(ciImage: $0) }
      guard ciImages.count == rgbaImages.count else { return .failure(NSError("Colorize.colorize() - some rgbaImages was not created")) /*Swift.print();return nil*/ }
      guard let result: RGBAImage = try? colorize(rgbaImages: rgbaImages, colorMap: colorMap, multipliers: multipliers) else { return .failure(NSError("Colorize.colorize() - Unable to create colorized rgbaImage")) }
      // ⚠️️ the bellow needs to not be grayscale
      guard let ciImage: CIImage = try? RGBAImageUtil.ciImg2(rgbaImage: result, useGrayscale: false/*, scale: CGFloat(multipliers.screenScale)*/) else { return .failure(NSError("Colorize.colorize() - Unable to convert to UIImage"))/*Swift.print();return nil*/ }
      result.deinitiate() // ⚠️️⚠️️ We get a mem leak in iOS if we don't deallocate the pixels ⚠️️⚠️️
      return .success(ciImage)
   }
}
