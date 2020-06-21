import Foundation
import QuartzCore
import CoreImage
/**
 * Converts b&w layers into color layers (Used in the HCCQR-creation-process)
 */
final class Colorizer {}
/**
 * CIImage
 */
extension Colorizer {
   /**
    * CIImage's -> RGBAImage -> CIImage
    * - Abstract: Converts multiple b&w images to color-image based on the defined colorMap
    * 1. Two B&W-QR-CIImage's comes in
    * 2. A HCCQR Color RGBAImage is created from the grayscale QR-Images
    * 3. Converts the RGBA image to ciImage and returns it
    * - Note: We get CIImages because thats what QR produces
    * - Note: Used in the process of converting Data to HCCQR (the QRImages are pure black and white)
    * - Return: we return a color CIImage
    * - Parameters:
    *   - ciImages: qr code images (BGRA8, opaque) (B&W QR-Images)
    *   - colorMap: rule-set (The color depth you want the HCCQR image in. 4, 8, 16, 32 etc)
    *   - multipliers: modulescale and screenScale, for retina you need 2x scale etc, This is the multiplier. ModuleCount equals 1 pixel. ModuleCount for QRVersion 10 is 57 not counting 2 for margins. So (57+2)*6 = 354, if you want 2xretina its 354 * 2 = 708
    */
   static func colorize(ciImages: [CIImage], colorMap: ColorMap, multipliers: Multipliers) -> ColorizedResult {
      guard let rgbaImage: RGBAImage = try? colorize(ciImages: ciImages, colorMap: colorMap, multipliers: multipliers) else { return .failure(.unableToCreateRGBAImageFromQRImages) }
      guard let ciImage: CIImage = try? RGBAImageParser.ciImg2(rgbaImage: rgbaImage, useGrayscale: false/*, scale: CGFloat(multipliers.screenScale)*/) else { return .failure(.unableToConvertRGBAToImage)/*Swift.print();return nil*/ }
      rgbaImage.deinitiate() // ⚠️️⚠️️ We dealloc pixels after they are consumed, We get a mem leak in iOS if we don't deallocate the pixels ⚠️️⚠️️
      return .success(ciImage)
   }
}
/**
 * Monotone
 */
extension Colorizer {
   /**
    * QRImages -> RGBAImage
    * - Abstract: Part of the HCCQR-creation process
    * 1. Array of CIImages comes in
    * 2. Convert the CIImage-array to Monotone pixel representations
    * 3. Colorize the Monotone array to an RGBAImage and return it
    * - Fixme: ⚠️️ Use ConcurrentPerform in conjunction with image quadrants / cores, threads
    */
   static func colorize(ciImages: [CIImage], colorMap: ColorMap, multipliers: Multipliers) throws -> RGBAImage {
      let monotoneImages: [MonotoneRep] = ciImages.compactMap { try? MonotoneRep.monotoneRep(ciImg: $0) } // convert QR images to Pixel-data
//      guard ciImages.count == monotoneImages.count else { throw NSError("Colorize.colorize() - some rgbaImages was not created") }
      let result: RGBAImage = colorize(monotoneImages: monotoneImages, colorMap: colorMap, multipliers: multipliers)// else { throw NSError("Colorize.colorize() - Unable to create colorized rgbaImage") } // overlay the qr-pixel-data
      return result
   }
}
