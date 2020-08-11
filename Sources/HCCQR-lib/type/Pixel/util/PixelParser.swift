#if os(iOS)
import UIKit
#elseif os(macOS)
import Cocoa
#endif

public final class PixelParser {
   /**
    * - Note: HalfThreshold of UInt8(63) equals 25% error tolerance
    * - Note: HalfThreshold of UInt8(50) equals 20% error tolerance
    * - Fixme: ⚠️️ Seems like you need aditional threshold for higher capacity hccqr, set accordingly when needed
    * - 0.2 seems sufficient for 4-color, and 0.3 for 8 color, 16colors seem to need more than 0.3
    */
   public static var sensitivity: CGFloat = 0.3
   /**
    * - Note: Percentage of color (UInt8(51) means can be 20% of some color) (4-color-system)
    * - Note: Used by the similarities method (not called frequently)
    * - Note: We use finer threshold if we use more colors (0.5 for 4-color, 0.125 for 8-color)
    * - Fixme: ⚠️️ figure out a better algorith, this one isn't very precise. Also consider individual thresholds, as some scheme channels are divided by and other 4 etc
    * ## Examples:
    * PixelParser.getHalfThreshold(4)
    * - Parameter numOfColors: number of colors in CType
    */
   internal static func getHalfThreshold(_ numOfColors: Int) -> UInt8 {
      let tessellation: Int = Self.tessellation(numOfColors: numOfColors)
//      let numOfLayers: Int = BoolColumn.numOfLayers(numOfColors: numOfColors)
      let halfThreshold: CGFloat = sensitivity / CGFloat(tessellation) // Rename to defaultHalfThreshold
      return UInt8(255.0 * halfThreshold) // Rename to defaultHalfThreshold
   }
   /**
    * Color tessellation
    */
   private static func tessellation(numOfColors: Int) -> Int {
      switch numOfColors {
      case 4: return 1
      case 8: return 2
      case 16, 32, 64: return 3
      case 128, 256: return 4
      default: fatalError("num of colors not supported: \(numOfColors)")
      }
   }
   /**
    * Get strength of a color against another
    * - Note: 100% percentage = 255
    * - Description: we calc how similar a color is to another in percentage 99% a color is 99% cyan, 88% magenta, 22% green etc,
    * - Discussion: the problem with this method is that one channel can be totally off and other can be exact same and it still return true, it should fail if one channel is totally off, but since we do the bool assert in conjunction with this method, then it works
    * - Discussion: so the red channel is always dominating, green is weakest etc. Look into this phenomenome, some grayscale conversion algos account for this etc
    * - Fixme: ⚠️️ Figure out how to divide a value that is bigger than UINT8.max etc and then divide it etc
    * - Fixme: ⚠️️ Maybe optimize this methods somehow? research? Converting to Int is not optimal
    * - Fixme: ⚠️️ It might be the case that if we should also limit the combined values of difference. say if R,B combined are more than 50% off, then its not a match. etc. It might be valuable to make advance tests, of how to match colors
    * - Fixme: ⚠️️ Rename to commonality, correlation?
    * - Fixme: ⚠️️ Performance could be increased if we did the dividing in bulk, on gpu etc
    * - Fixme: ⚠️️ Could be faster to do minMax instead of abs?
    * - Important: ⚠️️⚠️️⚠️️ has to be used in conjunction with the isColorish method, since this only returns the intensity of the output pixel, and should only valid if the isColorish method is within thresholds etc
    * ## Examples:
    * let red: RGBColor = (r: 255, g: 0, b: 0)
    * let redish: RGBColor = (r: 215, g: 20, b: 10)
    * let test1: UInt8 = similarity(a: redish, b: red) // 231
    * - Parameters:
    *   - a: static color (cyan, magenta, red etc)
    *   - b: dynamic color (cyan-ish, meganta-ish, red-ish etc)
    */
   internal static func similarity(a: Pixel, b: Pixel) -> UInt8 {
      let distR: Int = a.r.difference(b.r)
      let distG: Int = a.g.difference(b.g)
      let distB: Int = a.b.difference(b.b)
      return UInt8(255 - (distR + distG + distB) / 3)
   }
}
/**
 * Util for Pixel
 */
extension PixelParser {
   private typealias RGBAColor = (CGFloat, CGFloat, CGFloat, CGFloat)
   /**
    * Color -> (r: UInt8, g: UInt8 ,b: UInt8, a: UInt8)
    * - Fixme: ⚠️️ You can also probably do (maybe faster?): UIColor.blue.colorComponents // (red: 0.0, green: 0.0, blue: 1.0, alpha: 1.0)
    * - Important: ⚠️️ probably slow, but prob only used in tests
    */
   static func rgba(uiColor: Color) throws -> Pixel {
      var (r, g, b, a): RGBAColor = (0, 0, 0, 0)
      #if os(iOS)
      guard uiColor.getRed(&r, green: &g, blue: &b, alpha: &a) else { throw RGBAError.couldNotExtractRGBAComponents }
      #elseif os(macOS)
      guard let ciColor = CIColor(color: uiColor) else { throw RGBAError.couldNotConvertNSColorToCIColor }
      r = ciColor.red // 1.0
      g = ciColor.green // 0.0
      b = ciColor.blue // 0.0
      #else
      throw RGBAError.osNotSupported
      #endif
      return Pixel(r: UInt8(r * 255.0), g: UInt8(g * 255.0), b: UInt8(b * 255.0)/*, a: UInt8(a * 255.0)*/ )
   }
}
/**
 * Error
 */
extension PixelParser {
   internal enum RGBAError: Error {
      case couldNotExtractRGBAComponents
      case couldNotConvertNSColorToCIColor
      case osNotSupported
   }
}
