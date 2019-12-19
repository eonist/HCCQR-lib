import Foundation
import QuartzCore
import CoreImage

extension Colorizer {
   /**
    * ciImages -> CIImage
    */
   static func colorize(ciImages: [CIImage], colorMap: ColorMap, multipliers: Multipliers) throws -> CIImage {
      let rgbaImages: [RGBAImage] = ciImages.compactMap { try? RGBAImage.rgbaImage(ciImage: $0) }
      guard ciImages.count == rgbaImages.count else { throw "Colorize.colorize() - some rgbaImages was not created" /*Swift.print();return nil*/ }
      guard let result: RGBAImage = try? colorize(rgbaImages: rgbaImages, colorMap: colorMap, multipliers: multipliers) else { throw "Colorize.colorize() - Unable to create colorized rgbaImage" }
      guard let ciImage: CIImage = try? RGBAImageUtil.ciImage(rgbaImage: result/*, scale: CGFloat(multipliers.screenScale)*/) else { throw "Colorize.colorize() - Unable to convert to UIImage"/*Swift.print();return nil*/ }
      result.deinitiate() // ⚠️️⚠️️ We get a mem leak in iOS if we don't deallocate the pixels ⚠️️⚠️️
      return ciImage
   }
}
