#if os(iOS)
import UIKit
#elseif os(macOS)
import Cocoa
#endif
/**
 * Util
 * - Fixme: ⚠️️ Can be moved to Extension
 */
internal final class ImageUtil {
   /**
    * CGImage -> Image (Universal for ios and mac)
    */
   internal static func image(cgImage: CGImage, scale: CGFloat = 1) -> Image {
      #if os(iOS)
      return uiImage(cgImage: cgImage, scale: scale)
      #elseif os(macOS)
      return nsImage(cgImage: cgImage)
      #else
      fatalError("other OS not supported")/*Other os etc*/
      #endif
   }
   /**
    * Image -> CGImage (Universal for ios and mac)
    */
   static func cgImage(image: Image) -> CGImage? {
      #if os(iOS)
      guard let cgImage = image.cgImage ?? image.cgImage() else { return nil }
      return cgImage
      #elseif os(macOS)
      guard let cgImage = /* image.cgImage ??*/ image.cgImage() else { return nil }
      return cgImage
      #else
      Swift.print("other os not supported")
      return nil
      #endif
   }
   /**
    * CIImage -> UIImage
    * - NOTE: Helper method for QR images
    * - Fixme: ⚠️️ Make this throw
    */
   #if os(iOS)
   private static func uiImage(cgImage: CGImage, scale: CGFloat) -> UIImage {
      let image: UIImage = .init(cgImage: cgImage, scale: scale, orientation: .up)//.leftMirrored
      return image
   }
   #endif
   /**
    * CIImage -> NSImage
    * - Note: Helper method for QR images
    * - Fixme: ⚠️️ Make this throw
    */
   #if os(macOS)
   private static func nsImage(cgImage: CGImage) -> NSImage {
      let nsImg: NSImage = .init(cgImage: cgImage, size: .init(width: cgImage.width, height: cgImage.height))
      return nsImg
   }
   #endif
}
