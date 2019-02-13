#if os(iOS)
import UIKit
#elseif os(macOS)
import Cocoa
#endif
/**
 * Util.
 * - TODO: ⚠️️ Can be moved to Extension
 */
internal final class ImageUtil{
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
      let nsImg:NSImage = NSImage.init(cgImage: cgImage, size: CGSize.init(width: cgImage.width, height: cgImage.height))
      return nsImg
   }
   #endif
}




/**
 * Creates a CIImage from str
 * TODO: ⚠️️ make this throw
 */
//static func ciImage(str: String, size: CGSize) -> CIImage? {
//   let data = str.data(using: .utf8) // let data = codeValue.dataUsingEncoding(NSISOLatin1StringEncoding, allowLossyConversion: false)
//   guard let filter = CIFilter(name: "CIQRCodeGenerator") else {
//      return nil
//   }
//   filter.setValue(data, forKey: "inputMessage")
//   filter.setValue("Q", forKey: "inputCorrectionLevel")/*Correction levels aviable 7%, M 15%, Q25%, H:30*/
//   let res: Int = 8 // 8 seems to be a value which isn't too CPU concuming to render and keeps the size of the image correct
//   let interp:(x:CGFloat, y: CGFloat) = ((size.w / 100) * res, (size.h / 100) * res)
//   // Swift.print("interp:  \(interp)")
//   let codeImage: CIImage? =  filter.outputImage?.transformed(by: CGAffineTransform(scaleX: interp.x, y: interp.y))
//   return codeImage
//}

