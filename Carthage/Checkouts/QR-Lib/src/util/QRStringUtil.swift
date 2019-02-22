import Foundation
/**
 * - Description: Image 👉 String
 * - TODO: ⚠️️ rename to QRStringReader
 */
final public class QRStringUtil {
   #if os(iOS)
   /**
    * Returns a string for an UIImage with a QRCode
    * ## Examples:
    * qrCode(image: image)
    * - TODO: ⚠️️ rename to string(image)
    */
   public static func qrCode(image: Image) throws -> String {
      guard let ciImage:CIImage = image.ciImage ?? image.ciImage() else {throw "QRLib.QRStringUtil.qrCode() - Unable to get CIImage" }
      return try qrCode(ciImage: ciImage)
   }
   #endif
   /**
    * Returns a string for a CIImage instance
    * - TODO: ⚠️️ check if topLeft is the same as bounds.topleft, if not you have a more use-full rectangle outline
    * - Note: there is feature.symbolDescriptor,feature.bounds,feature.topLeft,ciImage.extent(size)
    * - Note: There is also: CIDetectorAccuracyLow, which has better performance
    * - TODO: ⚠️️ rename to stringAndFrame?
    */
   public static func qrCode(ciImage: CIImage) throws -> StringAndFrame {
      guard let feature:CIQRCodeFeature = try? ciImage.qrCodeFeature() else {throw ("QRStringUtil.qrCode - Unable to create CIQRCodeFeature") }
      let qrFrame:CGRect = .init(origin: feature.topLeft, size: feature.bounds.size)
      guard let msgStr = feature.messageString else {throw "QRStringUtil.qrCode - Unable to get msgStr"}
      return (qrStr: msgStr, qrFrame: qrFrame)
   }
   /**
    * Returns a string for an CIImage with a QRCode
    * - Note: There is also: CIDetectorTypeFace
    */
   fileprivate static func qrCode(ciImage: CIImage) throws -> String {
      guard let feature:CIQRCodeFeature = try? ciImage.qrCodeFeature() else {throw "QRLib.QRUtil.qrCode() - Unable to get qrCodeFeature"}
      guard let messageString:String = feature.messageString else {throw "QRLib.QRUtil.qrCode() - Unable to get messageString"}
      return messageString
   }
}
/**
 * Type
 */
extension QRStringUtil{
   public typealias StringAndFrame = (qrStr: String, qrFrame: CGRect)
}
