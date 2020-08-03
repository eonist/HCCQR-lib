import Foundation
import QuartzCore
import CoreImage
/**
 * Converts b&w layers into a color layer (Used in the HCCQR-creation-process)
 */
public final class Colorizer {}
/**
 * Monotone
 */
extension Colorizer {
   /**
    * Colorize layers to rgbaRep (QRImages -> RGBAImage)
    * - Abstract: Part of the HCCQR-creation process
    * - Note: We get CIImages because thats what QR produces
    * - Note: Used in the process of converting Data to HCCQR (the QRImages are pure black and white)
    * - Note: while benchmarking this method, it takes about half the time of the entire writing process, where the other half is consumed by the QR creation process
    * - Note: putting compactMap on concurrentCompactMap doesn't seem to improve already fast speeds
    * - Returns: RGBARep
    * - Parameters:
    *   - config: scale and pallet
    *   - qrLayers: qr layers as CIImages
    */
   internal static func colorize(qrLayers: [CIImage], config: OutputConfig) throws -> RGBARep {
      let monoReps: MonoReps = try qrLayers.map { try MonoRep.monoRep(ciImg: $0) }
      defer { monoReps.forEach { $0.pixels.deallocate() } }
      return colorize(monoReps: monoReps, config: config)
   }
}
