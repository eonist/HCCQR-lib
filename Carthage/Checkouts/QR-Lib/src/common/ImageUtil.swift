#if os(iOS)
import UIKit
#elseif os(macOS)
import Cocoa
#endif
/**
 * Util
 * - Fixme: ⚠️️ Can be moved to Util or Extensions
 */
internal final class ImageUtil {
   /**
    * Universal for ios and mac
    */
   internal static func image(ciImage: CIImage) -> Image {
      #if os(iOS)
      return uiImage(ciImage: ciImage)
      #elseif os(macOS)
      return nsImage(ciImage: ciImage)
      #else
      fatalError("other OS not supported")/*Other os etc*/
      #endif
   }
   /**
    * Converts ciImage to UIImage
    * - Note: Helper method for QR images
    * - Fixme: ⚠️️ Make this throw
    */
   #if os(iOS)
   private static func uiImage(ciImage: CIImage) -> UIImage {
      let uiImage: UIImage = .init(ciImage: ciImage)
      return uiImage
   }
   #endif
   /**
    * Converts ciImage to NSImage
    * - Note: Helper method for QR images
    * - Fixme: ⚠️️ Make this throw
    */
   #if os(macOS)
   private static func nsImage(ciImage: CIImage) -> NSImage {
      let rep: NSCIImageRep = .init(ciImage: ciImage)
      let nsImg: NSImage = .init(size: rep.size)
      nsImg.addRepresentation(rep)
      return nsImg
   }
   #endif
}
