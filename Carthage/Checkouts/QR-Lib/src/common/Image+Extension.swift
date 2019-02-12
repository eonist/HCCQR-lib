#if os(iOS)
import UIKit
#elseif os(macOS)
import Cocoa
#endif
/**
 * Util.
 * - TODO: ⚠️️ Can be moved to Util or Extensions
 */
internal final class ImageUtil{
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
    * - NOTE: Helper method for QR images
    * - TODO: ⚠️️ Make this throw
    */
   #if os(iOS)
   private static func uiImage(ciImage: CIImage) -> UIImage {
      let uiImage:UIImage = UIImage.init(ciImage: ciImage)
      return uiImage
   }
   #endif
   /**
    * Converts ciImage to NSImage
    * - Note: Helper method for QR images
    * - TODO: ⚠️️ Make this throw
    */
   #if os(macOS)
   private static func nsImage(ciImage: CIImage) -> NSImage {
      let rep:NSCIImageRep = NSCIImageRep.init(ciImage: ciImage)
      let nsImg:NSImage = NSImage.init(size: rep.size)
      nsImg.addRepresentation(rep)
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

