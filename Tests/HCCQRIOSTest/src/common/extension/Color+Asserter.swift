import Foundation
import QuartzCore
import CoreImage
@testable import HCCQR_lib
/**
 * Assert
 */
extension Color {
   /**
    * isEqualRGBA
    */
   func isEqualRGBA(uiColor: Color) -> Bool {
      let rgba1 = self.rgba
      let rgba2 = uiColor.rgba
      var r: Bool { rgba1.r == rgba2.r }
      var g: Bool { rgba1.g == rgba2.g }
      var b: Bool { rgba1.b == rgba2.b }
      var a: Bool { rgba1.a == rgba2.a }
      return r && g && b && a
   }
}
/**
 * ⚠️️ SLOW ⚠️️
 */
extension Color {
   /**
    * Returns rgba (0-1)
    * ## Examples:
    * UIColor.red.rgba.r // 1
    */
   private var rgba: (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
      let ciColor: CIColor = self.ciColor
      return (ciColor.red, ciColor.green, ciColor.blue, ciColor.alpha)
   }
}
