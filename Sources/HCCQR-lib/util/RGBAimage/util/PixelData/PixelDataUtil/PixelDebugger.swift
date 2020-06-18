import Foundation
/**
 * Debugging
 */
final class PixelDataDebugger {
   internal func isRed(pixelData: Pixel) -> Bool {
      Swift.print("Don't use this in prod")
      return pixelData.r == 255 && pixelData.g == 0 && pixelData.b == 0
   }
   internal func isBlue(pixelData: Pixel) -> Bool {
      Swift.print("Don't use this in prod")
      return pixelData.r == 0 && pixelData.g == 0 && pixelData.b == 255
   }
   internal func isGreen(pixelData: Pixel) -> Bool {
      Swift.print("Don't use this in prod")
      return pixelData.r == 0 && pixelData.g == 255 && pixelData.b == 0
   }
   /**
    * Debug help
    */
   func debug(pixelData: Pixel) {
      Swift.print("pixel.R:  \(pixelData.r)")
      Swift.print("pixel.G:  \(pixelData.g)")
      Swift.print("pixel.B:  \(pixelData.b)")
   }
}
