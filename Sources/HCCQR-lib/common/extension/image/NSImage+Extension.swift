#if os(macOS)
import Cocoa
extension NSImage {
   /**
    * ⚠️️ temp fix ⚠️️, might not work
    */
   internal func ciImage() -> CIImage? {
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
      return Optional(NSImage(size: size, color: color, scale: scale))
   }
   /**
    * - Note: Great to use un hybrid systems, as ios has the same API
    */
   convenience init(ciImage: CIImage) {
      let rep: NSCIImageRep = .init(ciImage: ciImage)
      self.init(size: rep.size)
      self.addRepresentation(rep)
   }
   /**
    * NSImage -> png
    */
   func pngData() -> Data? {
      guard let data = tiffRepresentation, let bitmap = NSBitmapImageRep(data: data), let png = bitmap.representation(using: .png, properties: [:]) else { return nil }
      return png
   }
}
#endif
