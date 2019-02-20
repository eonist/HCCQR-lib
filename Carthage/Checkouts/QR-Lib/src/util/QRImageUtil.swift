import Foundation
/**
 * - Description: String or Data 👉 Image
 */
final public class QRImageUtil {
   /**
    * Creates QR image from a string
    * ## Examples:
    * let image = QRUtil.qrImage(str: "testing", size: .init(width:100,height:100))
    * - Parameter str: The message you want the QR to contain
    * - Parameter size: The size you want the QR to be
    */
   public static func qrImage(str:String, size:CGSize?, ecLevel:ECLevel = .l) throws -> Image {
      guard let ciImage:CIImage = try? QRImageUtil.ciImage(str: str, size: size, ecLevel:ecLevel) else { throw ("⚠️️ QRLib.QRUtil.qrImage() - Failed to create ciImage ecLevel:\(ecLevel.rawValue) str.count:\(str.count) size:\(String(describing: size)) ⚠️️") }
      let image:Image = ImageUtil.image(ciImage: ciImage)// else {Swift.print("⚠️️ QRLib.QRUtil.qrImage() - Failed to create uiImage ⚠️️");return nil}
      return image
   }
   /**
    * Data -> qrImage (⚠️️ new ⚠️️)
    * - Important: ⚠️️⚠️️⚠️️ Make sure data.count is the same as the QRVersion allows, or else it will be hard to pull the data out again. With the current data extraction methods anyways
    */
   public static func qrImage(data:Data, size:CGSize?, ecLevel:ECLevel = .l) throws -> Image {
      guard let ciImage:CIImage = try? QRImageUtil.ciImage(data: data, size: size, ecLevel:ecLevel) else { throw ("⚠️️ QRLib.QRUtil.qrImage() - Failed to create ciImage ecLevel:\(ecLevel.rawValue) data.count:\(data.count) size:\(String(describing: size)) ⚠️️") }
      let image:Image = ImageUtil.image(ciImage: ciImage)
      return image
   }
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
    * - NOTE: allowLossyConversion: If true, then allows characters to be removed or altered in conversion. (https://developer.apple.com/documentation/foundation/nsstring/1413692-data)
    */
   public static func ciImage(str: String, size: CGSize?, ecLevel:ECLevel) throws -> CIImage {
      guard let data:Data = str.data(using: .utf8, allowLossyConversion: false) else {throw ("QRLib.QRUtil.ciImage() - Unable to create data") }
      return try ciImage(data: data, size: size, ecLevel: ecLevel)
   }
   /**
    * Data -> CIImage
    */
   public static func ciImage(data:Data, size:CGSize?, ecLevel:ECLevel) throws -> CIImage {
      guard let filter:CIFilter = CIFilter(name: "CIQRCodeGenerator") else {throw ("QRLib.QRUtil.ciImage() - Unable to create filter")  }
      filter.setValue(data, forKey: "inputMessage")
      filter.setValue(ecLevel.rawValue, forKey: "inputCorrectionLevel")
      guard let outputImage:CIImage = filter.outputImage else { throw ("QRLib.QRUtil.ciImage() - Unable to make CIImage for ecLevel:\(ecLevel.rawValue) str.count:\(data.count) size:\(String(describing: size))")  }
      outputImage.autoAdjustmentFilters()
      if let size = size {
         let scale:CGPoint = .init(x:size.width / outputImage.extent.width,y:size.height / outputImage.extent.height)
         let transformedImage:CIImage = outputImage.transformed(by: CGAffineTransform(scaleX: scale.x, y: scale.y))
         return transformedImage
      }else{
         return outputImage
      }
   }
}
/**
 * DEPRECATED
 */
extension QRImageUtil{
   /**
    * Creates NSView with nsImage (macOS)
    * Note: Convenience method
    * - TODO: ⚠️️ Move this out of this lib and into app libs using this lib 👌
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
