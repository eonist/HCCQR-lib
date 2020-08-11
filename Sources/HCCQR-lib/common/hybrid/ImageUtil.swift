#if os(iOS)
import UIKit
#elseif os(macOS)
import Cocoa
#endif
/**
 * Util
 * - Fixme: ⚠️️ Can be moved to Extension?
 * - Fixme: ⚠️️ Maybe make as lib, as QRLib also use the exact same lib
 */
internal final class ImageUtil {
   /**
    * Returns Image for CIImage (Universal for ios and mac)
    */
   internal static func image(ciImage: CIImage, scale: CGFloat = 1) -> Image {
      #if os(iOS)
      return uiImage(ciImage: ciImage, scale: scale)
      #elseif os(macOS)
      return nsImage(ciImage: ciImage)
      #else
      fatalError("other OS not supported") // Other os etc
      #endif
   }
   /**
    * CGImage -> Image (Universal for iOS and mac)
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
    * Image -> CGImage (Universal for iOS and mac)
    * - Fixme: ⚠️️ Maybe add throws?
    */
   static func cgImage(image: Image) -> CGImage? {
      #if os(iOS)
      return image.cgImage()
      #elseif os(macOS)
      return image.cgImage()
      #else
      fatalError("other OS not supported")/*Other os etc*/
      #endif
   }
}
/**
 * Private helper
 */
extension ImageUtil {
   /**
    * CIImage -> UIImage
    * - Note: Helper method for QR images
    * - Fixme: ⚠️️ Make this throw?
    */
   #if os(iOS)
   private static func uiImage(cgImage: CGImage, scale: CGFloat) -> UIImage {
      .init(cgImage: cgImage, scale: scale, orientation: .up) // .leftMirrored
   }
   /**
    * Converts ciImage to UIImage
    * - Note: Helper method for QR images
    * - Fixme: ⚠️️ Make this throw?
    */
   private static func uiImage(ciImage: CIImage, scale: CGFloat) -> UIImage {
      .init(ciImage: ciImage, scale: scale, orientation: .up)
   }
   #endif
   #if os(macOS)
   /**
    * Converts ciImage to NSImage
    * - Note: Helper method for QR images
    * - Fixme: ⚠️️ Make this throw?
    */
   private static func nsImage(ciImage: CIImage) -> NSImage {
      let rep: NSCIImageRep = .init(ciImage: ciImage)
      let nsImg: NSImage = .init(size: rep.size)
      nsImg.addRepresentation(rep)
      return nsImg
   }
   /**
    * CIImage -> NSImage
    * - Note: Helper method for QR images
    * - Fixme: ⚠️️ Make this throw?
    */
   private static func nsImage(cgImage: CGImage) -> NSImage {
      .init(cgImage: cgImage, size: .init(width: cgImage.width, height: cgImage.height))
   }
   #endif
}
