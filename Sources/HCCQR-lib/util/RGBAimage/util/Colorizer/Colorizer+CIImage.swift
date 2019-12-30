import Foundation
import QuartzCore
import CoreImage
/**
 * CIImage
 */
extension Colorizer {
   /**
    * CIImage's -> CIImage
    * - Abstract: creates an HCCQR from two Qr images
    * - Note: We get CIImages because thats what QR produces
    * - Note: Used in the process of converting Data to HCCQR
    * - Return: we return a color CIImage
    * - Parameters:
    *   - ciImages: qr code images
    *   - colorMap: ruleset
    *   - multipliers: scaling
    */
   static func colorize(ciImages: [CIImage], colorMap: ColorMap, multipliers: Multipliers) -> ColorizedResult {
      guard let rgbaImage: RGBAImage = try? colorize(ciImages: ciImages, colorMap: colorMap, multipliers: multipliers) else { return .failure(NSError("err creating RGBAImage from QR CIImages")) }
      guard let ciImage: CIImage = try? RGBAImageUtil.ciImg2(rgbaImage: rgbaImage, useGrayscale: false/*, scale: CGFloat(multipliers.screenScale)*/) else { return .failure(NSError("Colorize.colorize() - Unable to convert to UIImage"))/*Swift.print();return nil*/ }
      rgbaImage.deinitiate() // ⚠️️⚠️️ we dealloc pixels after they are consumed, We get a mem leak in iOS if we don't deallocate the pixels ⚠️️⚠️️
      return .success(ciImage)
   }
   /**
    * CIImage's -> RGBAImage
    * - Fixme: ⚠️️ Can we put the loop on bg-thread?
    */
   static func colorize(ciImages: [CIImage], colorMap: ColorMap, multipliers: Multipliers) throws -> RGBAImage {
      let rgbaImages: [RGBAImage] = ciImages.compactMap { try? RGBAImage.rgbaImg(ciImg: $0) }
      guard ciImages.count == rgbaImages.count else { throw NSError("Colorize.colorize() - some rgbaImages was not created") /*Swift.print();return nil*/ }
      guard let result: RGBAImage = try? colorize(rgbaImages: rgbaImages, colorMap: colorMap, multipliers: multipliers) else { throw NSError("Colorize.colorize() - Unable to create colorized rgbaImage") }
      return result
   }
}
