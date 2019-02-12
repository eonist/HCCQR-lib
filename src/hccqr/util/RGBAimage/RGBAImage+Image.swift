#if os(iOS)
import UIKit
#elseif os(macOS)
import Cocoa
#endif

/**
 * Util
 */
internal extension RGBAImage{
   /**
    * Universal for ios and mac
    */
   internal static func image(cgImage: CGImage, resultScale:CGFloat = 1) -> Image {
      #if os(iOS)
      return uiImage(cgImage: cgImage,resultScale:resultScale)
      #elseif os(macOS)
      return nsImage(cgImage: cgImage)
      #else
      fatalError("other OS not supported")/*Other os etc*/
      #endif
   }
   /**
    * Converts ciImage to UIImage
    * - NOTE: Helper method for QR images
    * - TODO: ⚠️️ Make this throw
    */
   #if os(iOS)
   private static func uiImage(cgImage: CGImage, resultScale:CGFloat) -> UIImage {
      let uiImage:UIImage = UIImage.init(cgImage: cgImage, scale: resultScale, orientation: .up)//.leftMirrored
      return uiImage
   }
   #endif
   /**
    * Converts ciImage to NSImage
    * - Note: Helper method for QR images
    * - TODO: ⚠️️ Make this throw
    */
   #if os(macOS)
   private static func nsImage(cgImage: CGImage) -> NSImage {
      let nsImg:NSImage = NSImage.init(cgImage: cgImage)
      return nsImg
   }
   #endif
}
