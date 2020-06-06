import Foundation
import QuartzCore
import CoreImage
/**
 * ciColor
 * - Fixme: ⚠️️ I'm Not sure if these are still used, if not remove them
 */
extension Color {
   #if os(iOS)
   var ciColor: CIColor { CIColor(color: self) }
   #elseif os(macOS)
   var ciColor: CIColor { CIColor(color: self) ?? { fatalError("Color - Unable to convert NSColor to CIColor") }() }
   #endif
}
