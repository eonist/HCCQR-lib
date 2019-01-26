#if os(iOS)
import UIKit
#elseif os(macOS)
import Cocoa
#endif
/**
 * This makes the code cross platform
 * - Note: by encapsulating it inside an extension we voids creating a global typalias Image
 */
extension QRUtil{
   #if os(iOS)
   public typealias Image = UIImage
   #elseif os(macOS)
   public typealias Image = NSImage
   #endif
}
/**
 * - From String to Image
 * - From Image to String
 */
final public class QRUtil {
   /**
    * Creates QR image from a string
    * ## Examples:
    * let image = QRUtil.qrImage(str: "testing", size: .init(width:100,height:100))
    * - Important: ⚠️️  243 char seems to be the limit string.count allowed
    * - TODO: ⚠️️ make this throw instead
    */
   public static func qrImage(str: String, size: CGSize) -> Image? {
      guard let ciImage: CIImage = QRUtil.ciImage(str: str, size: size) else {
         Swift.print("⚠️️ Failed to create ciImage ⚠️️");return nil
      }
      guard let image: Image = QRUtil.image(ciImage: ciImage) else {
         Swift.print("⚠️️ Failed to create uiImage ⚠️️");return nil
      }
      return image
   }
   /**
    * Returns a string for an UIImage with a QRCode
    * EXAMPLE: QRParser.qrCode(nsImage: image)
    */
   #if os(iOS)
   public static func qrCode(image: UIImage) -> String? {
      guard let ciImage = image.ciImage else {  return nil }
      return qrCode(ciImage: ciImage)
   }
   #endif
   public typealias StringAndFrame = (qrStr: String?, qrFrame: CGRect)
   /**
    * Returns a string for a CIImage instance
    * - TODO: ⚠️️ check if topLeft is the same as bounds.topleft, if not you have a more use-full rectangle outline
    * - Note: there is feature.symbolDescriptor,feature.bounds,feature.topLeft,ciImage.extent(size)
    */
   public static func qrCode(ciImage: CIImage) -> StringAndFrame? {
      let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])! // Yhere is also: CIDetectorTypeFace
      let features = detector.features(in: ciImage)
      if let feature = (features.first { $0 is CIQRCodeFeature } as? CIQRCodeFeature) {
         let qrFrame: CGRect = CGRect(origin: feature.topLeft, size: feature.bounds.size)
         return (qrStr: feature.messageString, qrFrame: qrFrame)
      }
      return nil
   }
   /**
    * Creates NSView with nsImage (macOS)
    */
   #if os(macOS)
   public static func imageView(nsImage: Image, rect: CGRect) -> NSImageView {
      let imageView = NSImageView(frame: rect)
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
    * - TODO: ⚠️️ Make this throw error instead of failing hard
    * - TODO: ⚠️️ this is different for mac. see deprecated code
    */
   fileprivate static func ciImage(str: String, size: CGSize) -> CIImage? {
      let data: Data? = str.data(using: .utf8)
      guard let filter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
      filter.setValue(data, forKey: "inputMessage")
      filter.setValue("L", forKey: "inputCorrectionLevel")/* Correction levels aviable L 7%, M 15%, Q 25%, H 30% */
      guard let outputImage = filter.outputImage else { fatalError("can't make ciimage") }
      let scale:CGPoint = .init(x:size.width / outputImage.extent.size.width, y:size.height / outputImage.extent.size.height)
      let transformedImage = outputImage.transformed(by: CGAffineTransform(scaleX: scale.x, y: scale.y))
      return transformedImage
   }
   /**
    * Returns a string for an CIImage with a QRCode
    */
   fileprivate static func qrCode(ciImage: CIImage) -> String? {
      let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])! // There is also: CIDetectorTypeFace
      let features = detector.features(in: ciImage)
      if let feature = (features.first { $0 is CIQRCodeFeature } as? CIQRCodeFeature) {
         return feature.messageString
      }
      return nil
   }
   /**
    * Universal for ios and mac
    */
   fileprivate static func image(ciImage: CIImage) -> Image? {
      #if os(iOS)
      return uiImage(ciImage: ciImage)
      #elseif os(macOS)
      return nsImage(ciImage: ciImage)
      #endif
   }
   /**
    * Converts ciImage to UIImage
    * - NOTE: Helper method for QR images
    * - TODO: ⚠️️ Make this throw
    */
   #if os(iOS)
   private static func uiImage(ciImage: CIImage) -> UIImage? {
      return UIImage(ciImage: ciImage)
   }
   #endif
   /**
    * Converts ciImage to NSImage
    * NOTE: Helper method for QR images
    * TODO: ⚠️️ Make this throw
    */
   #if os(macOS)
   private static func nsImage(ciImage: CIImage) -> NSImage? {
      let rep = NSCIImageRep(ciImage: ciImage)
      let nsImg = NSImage(size: rep.size)
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
