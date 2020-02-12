import Foundation
import QuartzCore
import CoreImage
/**
 * FAST
 */
extension Color {
   /**
    * 0-1
    */
   var redValue: CGFloat? { return cgColor.components?[0] }
   /**
    * 0-1
    */
   var greenValue: CGFloat? { return cgColor.components?[1] }
   /**
    * 0-1
    */
   var blueValue: CGFloat? { return cgColor.components?[2] }
   /**
    * 0-1
    */
   var alphaValue: CGFloat? { return cgColor.components?[3] }
   typealias ColorComponents = (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)
   /**
    * Probably faster than using self.getRed to get rgb
    * ## Examples:
    * UIColor.blue.colorComponents) // (red: 0.0, green: 0.0, blue: 1.0, alpha: 1.0)
    */
   var colorComponents: ColorComponents? {
      guard let c = self.cgColor.components else { Swift.print("Unable to get colorComponents"); return nil }
      return (red: c[0], green: c[1], blue: c[2], alpha: c[3])
   }
}
/**
 * SLOW
 */
extension Color {
   /**
    * Returns rgba (0-1)
    * ## Examples:
    * UIColor.red.rgba.r // 1
    */
   var rgba: (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
      let ciColor: CIColor = self.ciColor
      return (ciColor.red, ciColor.green, ciColor.blue, ciColor.alpha)
   }
   /**
    * Returns red 0-1
    */
   var r: CGFloat { return self.ciColor.red }
   var g: CGFloat { return self.ciColor.green }
   var b: CGFloat { return self.ciColor.blue }
   var a: CGFloat { return self.ciColor.alpha }
}
/**
 * ciColor
 */
extension Color {
   #if os(iOS)
   var ciColor: CIColor { return CIColor(color: self) }
   #elseif os(macOS)
   var ciColor: CIColor { return CIColor(color: self) ?? { fatalError("Color - Unable to convert NSColor to CIColor") }() }
   #endif
}
