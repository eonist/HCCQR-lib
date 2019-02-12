#if os(iOS)
import UIKit
#elseif os(macOS)
import Cocoa
#endif
/**
 * - Description: Image 👉 String
 */
final public class QRStringUtil {

   #if os(iOS)
   /**
    * Returns a string for an UIImage with a QRCode
    * ## Examples:
    * QRParser.qrCode(image: image)
    */
   public static func qrCode(image: Image) -> String? {
      guard let ciImage:CIImage = image.ciImage ?? image.ciImage() else {Swift.print("QRLib.QRUtil.qrCode() - Unable to get CIImage"); return nil }
      return qrCode(ciImage: ciImage)
   }
   #endif
   
   /**
    * Returns a string for a CIImage instance
    * - TODO: ⚠️️ check if topLeft is the same as bounds.topleft, if not you have a more use-full rectangle outline
    * - Note: there is feature.symbolDescriptor,feature.bounds,feature.topLeft,ciImage.extent(size)
    * - Note: There is also: CIDetectorAccuracyLow, which has better performance
    */
   public static func qrCode(ciImage: CIImage) -> StringAndFrame? {//TODO: ⚠️️ rename to stringAndFrame ?
      guard let detector:CIDetector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh]) else {Swift.print("unable to create CIDetectorTypeQRCode");return nil} // Yhere is also: CIDetectorTypeFace
      let features:[CIFeature] = detector.features(in: ciImage)
      guard let feature:CIQRCodeFeature = (features.first { $0 is CIQRCodeFeature } as? CIQRCodeFeature) else {Swift.print("Unable to create CIQRCodeFeature");return nil}
      let qrFrame:CGRect = .init(origin: feature.topLeft, size: feature.bounds.size)
      return (qrStr: feature.messageString, qrFrame: qrFrame)
   }
   
}
/**
 * Helpers
 */
extension QRStringUtil{
   
   /**
    * Returns a string for an CIImage with a QRCode
    * - Note: There is also: CIDetectorTypeFace
    */
   fileprivate static func qrCode(ciImage: CIImage) -> String? {
      guard let detector:CIDetector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh]) else {Swift.print("unable to create detector");return nil}
      let features:[CIFeature] = detector.features(in: ciImage)
      guard let feature:CIQRCodeFeature = (features.first { $0 is CIQRCodeFeature } as? CIQRCodeFeature) else {Swift.print("QRLib.QRUtil.qrCode() - Unable to get CIQRCodeFeature");return nil}
      guard let messageString:String = feature.messageString else {Swift.print("QRLib.QRUtil.qrCode() - Unable to get messageString");return nil}
      return messageString
   }
}
/**
 * Type
 */
extension QRStringUtil{
   public typealias StringAndFrame = (qrStr: String?, qrFrame: CGRect)
}
