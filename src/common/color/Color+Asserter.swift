import Foundation
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
      var r: Bool { return rgba1.r == rgba2.r }
      var g: Bool { return rgba1.g == rgba2.g }
      var b: Bool { return rgba1.b == rgba2.b }
      var a: Bool { return rgba1.a == rgba2.a }
      return r && g && b && a
   }
}
