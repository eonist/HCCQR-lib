#if os(macOS)
import Cocoa
/**
 * - Fixme: ⚠️️ Some of these may not be in use anymore, try to delte or move to test scope
 */
extension NSImage {
   /**
    * ⚠️️ Temp fix ⚠️️, might not work
    */
   func ciImage() -> CIImage? {
      guard let cgImage: CGImage = self.cgImage() else { Swift.print("QRLib.UIImage.ciImage() - unable to create cgimage"); return nil }
      return CoreImage.CIImage(cgImage: cgImage)
   }
   /**
    * ## Examples:
    * let redImage = NSImage.image(color: .red, size: .init(width: 128, height: 128))
    */
   convenience init(size: CGSize, color: NSColor, scale: CGFloat = 1.0) {
      self.init(size: size)
      lockFocus()
      color.drawSwatch(in: NSRect(origin: .zero, size: size))
      unlockFocus()
   }
   /**
    * Convenience
    */
   public static func image(size: CGSize, color: NSColor, scale: CGFloat = 1.0) -> NSImage? {
      Optional(NSImage(size: size, color: color, scale: scale))
   }
   /**
    * - Note: Great to use in hybrid systems, as iOS has the same API
    */
   convenience init(ciImage: CIImage) {
      let rep: NSCIImageRep = .init(ciImage: ciImage)
      self.init(size: rep.size)
      self.addRepresentation(rep)
   }
}
#endif
