#if os(iOS)
import UIKit
#elseif os(macOS)
import Cocoa
#endif
/**
 * This makes the code cross platform
 * - Note: by encapsulating it inside an extension we avoid creating a global typalias Image
 */
extension QRUtil{
   #if os(iOS)
   public typealias Image = UIImage
   #elseif os(macOS)
   public typealias Image = NSImage
   #endif
}
/**
 * - Description: String 👉 Image & Image 👉 String
 */
final public class QRUtil {
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
      guard let ciImage: CIImage = QRUtil.ciImage(str: str, size: size, ecLevel:ecLevel) else {
         Swift.print("⚠️️ Failed to create ciImage ecLevel:\(ecLevel.rawValue) str.count:\(str.count) size:\(size) ⚠️️");return nil
      }
      guard let image: Image = QRUtil.image(ciImage: ciImage) else {
         Swift.print("⚠️️ Failed to create uiImage ⚠️️");return nil
      }
      return image
   }
   /**
    * Returns a string for an UIImage with a QRCode
    * ## Examples:
    * QRParser.qrCode(nsImage: image)
    */
   #if os(iOS)
   public static func qrCode(image: UIImage) -> String? {
      guard let ciImage = image.ciImage else {Swift.print("unable to get CIImage"); return nil }
      return qrCode(ciImage: ciImage)
   }
   #endif
   public typealias StringAndFrame = (qrStr: String?, qrFrame: CGRect)
   /**
    * Returns a string for a CIImage instance
    * - TODO: ⚠️️ check if topLeft is the same as bounds.topleft, if not you have a more use-full rectangle outline
    * - Note: there is feature.symbolDescriptor,feature.bounds,feature.topLeft,ciImage.extent(size)
    * - Note: There is also: CIDetectorAccuracyLow, which has better performance
    */
   public static func qrCode(ciImage: CIImage) -> StringAndFrame? {
      guard let detector:CIDetector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh]) else {Swift.print("unable to create CIDetectorTypeQRCode");return nil} // Yhere is also: CIDetectorTypeFace
      let features:[CIFeature] = detector.features(in: ciImage)
      guard let feature:CIQRCodeFeature = (features.first { $0 is CIQRCodeFeature } as? CIQRCodeFeature) else {Swift.print("Unable to create CIQRCodeFeature");return nil}
      let qrFrame:CGRect = .init(origin: feature.topLeft, size: feature.bounds.size)
      return (qrStr: feature.messageString, qrFrame: qrFrame)
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
extension QRUtil{
   /**
    * Creates a CIImage from str
    * - TODO: ⚠️️⚠️️ Figure out if you account for scale in rendering the CIImage, think retina vs non retina. for retina scale is 2
    * - TODO: ⚠️️ Make this throw error instead of failing hard
    * - TODO: ⚠️️ this is different for mac. see deprecated code, i think its the same 🤔
    * - Note: Generates an output image representing the input data according to the ISO/IEC 18004:2006 standard. The width and height of each module (square dot) of the code in the output image is one point.
    * - Note: Correction levels available: L 7%, M 15%, Q 25%, H 30%
    * - Note: Encoding: NSISOLatin1StringEncoding is standard but ASCII or UTF-8 works too.
    */
   fileprivate static func ciImage(str: String, size: CGSize, ecLevel:ECLevel) -> CIImage? {
      guard let filter:CIFilter = CIFilter(name: "CIQRCodeGenerator") else {Swift.print("Unable to create filter"); return nil }
      guard let data:Data = str.data(using: .utf8, allowLossyConversion: true) else {Swift.print("Unable to create data");return nil}
      filter.setValue(data, forKey: "inputMessage")
      filter.setValue(ecLevel.rawValue, forKey: "inputCorrectionLevel")
      guard let outputImage:CIImage = filter.outputImage else { Swift.print("Unable to make CIImage for ecLevel:\(ecLevel.rawValue) str.count:\(str.count) size:\(size)"); return nil }
//      outputImage.description
      let scale:CGPoint = {
         let x = size.width / outputImage.extent.size.width
         let y = size.height / outputImage.extent.size.height
         return .init(x:x,y:y)
      }()
      let transformedImage:CIImage = outputImage.transformed(by: CGAffineTransform(scaleX: scale.x, y: scale.y))
      return transformedImage
   }
   /**
    * Returns a string for an CIImage with a QRCode
    * - Note: There is also: CIDetectorTypeFace
    */
   fileprivate static func qrCode(ciImage: CIImage) -> String? {
      guard let detector:CIDetector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh]) else {Swift.print("unable to create detector");return nil}
      let features:[CIFeature] = detector.features(in: ciImage)
      guard let feature:CIQRCodeFeature = (features.first { $0 is CIQRCodeFeature } as? CIQRCodeFeature) else {Swift.print("unable to get CIQRCodeFeature");return nil}
      guard let messageString:String = feature.messageString else {Swift.print("unable to get messageString");return nil}
      return messageString
   }
   /**
    * Universal for ios and mac
    */
   fileprivate static func image(ciImage: CIImage) -> Image? {
      #if os(iOS)
      return uiImage(ciImage: ciImage)
      #elseif os(macOS)
      return nsImage(ciImage: ciImage)
      #else
      return nil//other os etc
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
