#if os(iOS)
import UIKit
#elseif os(macOS)
import Cocoa
#endif
/**
 * - Description: String 👉 Image
 */
final public class QRImageUtil {
   /**
    * Creates QR image from a string
    * ## Examples:
    * let image = QRUtil.qrImage(str: "testing", size: .init(width:100,height:100))
    * - Important: ⚠️️  243 char seems to be the limit string.count allowed, 🚫 this is not correct.
    * - TODO: ⚠️️ make this throw instead
    * - Parameter str: The message you want the QR to contain
    * - Parameter size: The size you want the QR to be
    */
   public static func qrImage(str: String, size: CGSize, ecLevel:ECLevel = .l) -> Image? {
      guard let ciImage:CIImage = QRImageUtil.ciImage(str: str, size: size, ecLevel:ecLevel) else { Swift.print("⚠️️ QRLib.QRUtil.qrImage() - Failed to create ciImage ecLevel:\(ecLevel.rawValue) str.count:\(str.count) size:\(size) ⚠️️");return nil}
      let image:Image = ImageUtil.image(ciImage: ciImage)// else {Swift.print("⚠️️ QRLib.QRUtil.qrImage() - Failed to create uiImage ⚠️️");return nil}
      return image
   }
   /**
    * Creates NSView with nsImage (macOS)
    * Note: Convenience method
    */
   #if os(macOS)
   public static func imageView(nsImage: Image, rect: CGRect) -> NSImageView {
      let imageView:NSImageView = NSImageView(frame: rect)
      imageView.image = nsImage
      imageView.imageAlignment = .alignTopLeft
      // imageView.imageScaling = .scaleNone
      return imageView
   }
   #endif
}
/**
 * Helpers
 */
extension QRImageUtil{
   /**
    * Creates a CIImage from str
    * - TODO: ⚠️️⚠️️ Figure out if you account for scale in rendering the CIImage, think retina vs non retina. for retina scale is 2
    * - TODO: ⚠️️ Make this throw error instead of failing hard
    * - TODO: ⚠️️ this is different for mac. see deprecated code, i think its the same 🤔
    * - Note: Generates an output image representing the input data according to the ISO/IEC 18004:2006 standard. The width and height of each module (square dot) of the code in the output image is one point.
    * - Note: Correction levels available: L 7%, M 15%, Q 25%, H 30%
    * - Note: Encoding: NSISOLatin1StringEncoding is standard but ASCII or UTF-8 works too.
    * - Important: ⚠️️ scale is calculated from module: version1 has 23 modules, if you provide size: w:46,h:46 then the scale will be 2x
    */
   fileprivate static func ciImage(str: String, size: CGSize, ecLevel:ECLevel) -> CIImage? {
      guard let filter:CIFilter = CIFilter(name: "CIQRCodeGenerator") else {Swift.print("QRLib.QRUtil.ciImage() - Unable to create filter"); return nil }
      guard let data:Data = str.data(using: .utf8, allowLossyConversion: true) else {Swift.print("QRLib.QRUtil.ciImage() - Unable to create data");return nil}
      filter.setValue(data, forKey: "inputMessage")
      filter.setValue(ecLevel.rawValue, forKey: "inputCorrectionLevel")
      guard let outputImage:CIImage = filter.outputImage else { Swift.print("QRLib.QRUtil.ciImage() - Unable to make CIImage for ecLevel:\(ecLevel.rawValue) str.count:\(str.count) size:\(size)"); return nil }
      //      Swift.print("outputImage.description:  \(outputImage.description)")
      //      Swift.print("outputImage.extent:  \(outputImage.extent)")
      outputImage.autoAdjustmentFilters()
      let scale:CGPoint = {
         let x = size.width / outputImage.extent.size.width
         let y = size.height / outputImage.extent.size.height
         return .init(x:x,y:y)
      }()
      //      Swift.print("scale:  \(scale)")
      let transformedImage:CIImage = outputImage.transformed(by: CGAffineTransform(scaleX: scale.x, y: scale.y))
      return transformedImage
      //      return outputImage
   }
}
