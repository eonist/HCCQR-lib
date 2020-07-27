#if os(iOS)
import Foundation
import QuartzCore
import CoreImage
@testable import HCCQR_lib
/**
 * Asserter
 * - Note: Used for internal debugging
 */
final class ColorPalleteAsserter {
   /**
    * Asserts if an image has non black or white pixel.
    */
   static func hasOnlyBlackAndWhiteColorPallete(uiImage: Image) -> Bool {
      hasOnlyColorPallete(image: uiImage, scheme: [.black, .white])
   }
}
/**
 * internal helper
 */
extension ColorPalleteAsserter {
   /**
    * Asserts if an image has only the colors specified in the colors array
    * 1. Look for color that doesnt match
    * 2. if a color doesn't match drop out of searching further
    * 3. if all colors checkout, return true
    * - Abstract: ensure that img only has valid colors, aka no bluring
    * - Important: ⚠️️ This method is used for testing and debugging mostly
    * ## Example:
    * hasOnlyColorPallete(these: [.red, .green, .blue, .white])
    * - Note: this method is just for debugging, so no need to optimize it too much
    * - Parameters:
    *   - image: The image to assert if has color-map
    *   - pallete: the color-map to assert against
    */
   private static func hasOnlyColorPallete(image: Image, scheme: [Color]) -> Bool {
      let condition: (Color) -> Bool = { color in
         let matchCondition: (Color) -> Bool = {
            $0.isEqualRGBA(color: color)
         }
         let retVal = !scheme.contains(where: matchCondition)
         Swift.print("retVal:  \(retVal) color: \(color)")
         return retVal
      }
      let pixelColors = image.pixelColors // ⚠️️ this call is not performant, but it doesn't matter because its just a test, and not used in prod
      return !pixelColors.contains(where: condition) // this is very inefficient, you should rather search in the array while its being populated
   }
}
/**
 * Parsers
 */
extension Image {
   /**
    * Returns color of every pixel in an image
    * - Fixme: ⚠️️ Should return optional
    * - Only used by tests
    */
   var pixelColors: [Color] {
      // ⚠️️ The bellow fix could hurt performance
      guard let cgImage = /*self.cgImage ?? */ self.cgImage() else { Swift.print("getPixelColor() - unable to get cgImage"); return [] }
      guard let dataProvider = cgImage.dataProvider else { Swift.print("getPixelColor() - unable to get dataProvider"); return [] }
      guard let pixelData: CFData = dataProvider.data else { Swift.print("getPixelColor() - unable to get cfData"); return [] }
      let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
      let (width, height) = (Int(size.width), Int(size.height))
      return (0..<height).flatMap { y in
         (0..<width).compactMap { x in
            getPixelColor(pos: .init(x: x, y: y), data: data)
         }
      }
   }
}
/**
 * Internal helper method
 */
extension Image {
   /**
    * - Note: Somehow this works with retina images where scale is 2x as well
    * - Note: alternative: https://gist.github.com/giulio92/69e4f74217422154bb25d2a35d6710f8
    * - Fixme: ⚠️️ cgImage or CGImage doesn't always work, try to make this more consistent
    * - Fixme: ⚠️️ Make this throw
    * - Parameter pos: The x/y position in the image to grab color from
    */
   private func getPixelColor(pos: CGPoint) -> Color? { // Fixme: ⚠️️ make this for cgImage, converting it over and over is not good
      // ⚠️️ The bellow fix could hurt performance, its just for testing tho
      guard let cgImage = self.cgImage() else { Swift.print("getPixelColor() - unable to get cgImage"); return nil }
      guard let dataProvider = cgImage.dataProvider else { Swift.print("getPixelColor() - unable to get dataProvider"); return nil }
      guard let pixelData: CFData = dataProvider.data else { Swift.print("getPixelColor() - unable to get cfData"); return nil }
      let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
      return getPixelColor(pos: pos, data: data)
   }
   /**
    * Internal helper (get pixel from data)
    * - Parameters:
    *   - pos: The x/y position in the image to grab color from
    *   - data: all individual pixels from an image
    */
   private func getPixelColor(pos: CGPoint, data: UnsafePointer<UInt8>) -> Color? {
      let idx = Int((self.size.width * self.scale * pos.y) + pos.x) * 4
      let r = CGFloat(data[idx]) / 255
      let g = CGFloat(data[idx + 1]) / 255
      let b = CGFloat(data[idx + 2]) / 255
      let a = CGFloat(data[idx + 3]) / 255
      return .init(red: r, green: g, blue: b, alpha: a)
   }
}
#endif
