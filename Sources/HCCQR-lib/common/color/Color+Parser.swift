import Foundation
import QuartzCore
import CoreImage
/**
 * ciColor
 */
extension Color {
   #if os(iOS)
   var ciColor: CIColor { CIColor(color: self) }
   #elseif os(macOS)
   var ciColor: CIColor { CIColor(color: self) ?? { fatalError("Color - Unable to convert NSColor to CIColor") }() }
   #endif
}
