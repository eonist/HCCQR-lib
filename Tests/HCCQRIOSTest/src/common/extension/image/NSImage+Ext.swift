#if os(macOS)
import Cocoa

extension NSImage {
   /**
    * NSImage -> png
    */
   func pngData() -> Data? {
      guard let data = tiffRepresentation, let bitmap = NSBitmapImageRep(data: data), let png = bitmap.representation(using: .png, properties: [:]) else { return nil }
      return png
   }
}
#endif
