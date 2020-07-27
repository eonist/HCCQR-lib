import Foundation
import QuartzCore
import CoreImage
/**
 * Converts b&w layers into a color layer (Used in the HCCQR-creation-process)
 */
public final class Colorizer {}
/**
 * CIImage
 */
extension Colorizer {
   /**
    * CIImage's -> RGBAImage -> CIImage
    * - Abstract: Converts multiple b&w images to color-image based on the defined color-pallete
    * 1. Two B&W-QR-CIImage's comes in
    * 2. A HCCQR Color RGBAImage is created from the grayscale QR-Images
    * 3. Converts the RGBA image to ciImage and returns it
    * - Note: We get CIImages because thats what QR produces
    * - Note: Used in the process of converting Data to HCCQR (the QRImages are pure black and white)
    * - Return: we return a color CIImage
    * - Parameters:
    *   - ciImages: qr code images (BGRA8, opaque) (B&W QR-Images)
    *   - config: module and screen, for retina you need 2x scale etc, This is the multiplier. ModuleCount equals 1 pixel. ModuleCount for QRVersion 10 is 57 not counting 2 for margins. So (57+2)*6 = 354, if you want 2xretina its 354 * 2 = 708, rule-set (The color depth you want the HCCQR image in. 4, 8, 16, 32 etc)
    */
   static func colorize(ciImages: [CIImage], config: OutputConfig) -> ColorizerResult {
      guard let rgbaRep: RGBARep = try? colorize(ciImages: ciImages, config: config) else { return .failure(.unableToCreateRGBAImageFromQRImages) }
      guard let ciImage: CIImage = try? RGBARepParser.ciImg2(rgbaRep: rgbaRep, useGrayscale: false/*, scale: CGFloat(multipliers.screenScale)*/) else { return .failure(.unableToConvertRGBAToImage)/*Swift.print();return nil*/ }
      rgbaRep.deInitiate() // ⚠️️⚠️️ We dealloc pixels after they are consumed, We get a mem leak in iOS if we don't deallocate the pixels ⚠️️⚠️️
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
    * - Return: we return RGBARep
    * - Parameters:
    *   - ciImages: qr code images (BGRA8, opaque) (B&W QR-Images)
    *   - config: module and screen, for retina you need 2x scale etc, This is the multiplier. ModuleCount equals 1 pixel. ModuleCount for QRVersion 10 is 57 not counting 2 for margins. So (57+2)*6 = 354, if you want 2xretina its 354 * 2 = 708, rule-set (The color depth you want the HCCQR image in. 4, 8, 16, 32 etc)
    */
   static func colorize(ciImages: [CIImage], config: OutputConfig) throws -> RGBARep {
      let monoReps: MonoReps = try ciImages.map { try MonoRep.monoRep(ciImg: $0) } // convert QR images to Pixel-data
      return colorize(monoReps: monoReps, config: config)// else { throw NSError("Colorize.colorize() - Unable to create colorized rgbaImage") } // overlay the qr-pixel-data
   }
}
/**
 * Colorizer with (Quadrant optimization support) ⚠️️ New ⚠️️
 */
extension Colorizer {
   /**
    * Colorize layers to rgbaRep
    * - Note: while benchmarking this method, it takes about half the time of the entire writing process, where the other half is consumed by the QR creation process
    * - Note: putting compactMap on concurrentCompactMap doesn't seem to improve already fast speeds
    * - Returns: RGBARep
    * - Parameters:
    *   - coreCount: num of cores in CPU ProcessInfo().activeProcessorCount
    *   - qrLayers: qr layers as CIImages
    */
   internal static func colorize(qrLayers: [CIImage], config: OutputConfig) throws -> RGBARep {
      let monoReps: MonoReps = try qrLayers.map { try MonoRep.monoRep(ciImg: $0) }
      return colorize(monoReps: monoReps, config: config)
   }
}
