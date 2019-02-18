import Foundation
/**
 * - Description: Image 👉 String
 */
final public class QRStringUtil {//TODO: ⚠️️ rename to QRDataUtil
   #if os(iOS)
   /**
    * Returns a string for an UIImage with a QRCode
    * ## Examples:
    * qrCode(image: image)
    * - TODO: ⚠️️ rename to string(image)
    */
   public static func qrCode(image: Image) -> String? {//
      guard let ciImage:CIImage = image.ciImage ?? image.ciImage() else {Swift.print("QRLib.QRStringUtil.qrCode() - Unable to get CIImage"); return nil }
      return qrCode(ciImage: ciImage)
   }
   /**
    * Returns a string for an UIImage with a QRCode (⚠️️ New ⚠️️)
    * ## Examples:
    * - iOS provides descriptor in the cameraCapture call
    * qrCode(descriptor: descriptor)//Data()
    * - TODO: ⚠️️ rename to data(image)
    */
   public static func qrCode(descriptor:CIQRCodeDescriptor) -> Data? {//
      return descriptor.data
   }
   #endif
   /**
    * Returns a string for a CIImage instance
    * - TODO: ⚠️️ check if topLeft is the same as bounds.topleft, if not you have a more use-full rectangle outline
    * - Note: there is feature.symbolDescriptor,feature.bounds,feature.topLeft,ciImage.extent(size)
    * - Note: There is also: CIDetectorAccuracyLow, which has better performance
    * - TODO: ⚠️️ rename to stringAndFrame ?
    */
   public static func qrCode(ciImage: CIImage) -> StringAndFrame? {//
      guard let feature:CIQRCodeFeature = ciImage.qrCodeFeature else {Swift.print("Unable to create CIQRCodeFeature");return nil}
      let qrFrame:CGRect = .init(origin: feature.topLeft, size: feature.bounds.size)
      return (qrStr: feature.messageString, qrFrame: qrFrame)
   }
   /**
    * Returns data (New)
    * - TODO: ⚠️️ rename to data(image)
    * - Caution: ⚠️️⚠️️⚠️️ Make sure you fill up the Data to the exact max allowed bytes in the qrVersion you are using, or else white-space bytes will be added and converting back to utf8 gets trickier
    */
   public static func qrCode(ciImage: CIImage) -> Data? {
      guard let data:Data = ciImage.qrData else {Swift.print("unable to get qrData from ciImage");return nil}//errorCorrectedPayload
      return data
   }
   /**
    * Returns data + frame (New)
    * - TODO: ⚠️️ rename to dataAndFrame(image)
    * - Caution: ⚠️️⚠️️⚠️️ Make sure you fill up the Data to the exact max allowed bytes in the qrVersion you are using, or else white-space bytes will be added and converting back to utf8 gets trickier
    */
   public static func qrCode(ciImage: CIImage) -> DataAndFrame? {
      guard let feature:CIQRCodeFeature = ciImage.qrCodeFeature else {Swift.print("Unable to create CIQRCodeFeature");return nil}
      guard let data:Data = feature.data else {Swift.print("unable to get qrData from ciImage");return nil}//errorCorrectedPayload
      let qrFrame:CGRect = .init(origin: feature.topLeft, size: feature.bounds.size)
      return (qrData:data, qrFrame: qrFrame)
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
      guard let feature:CIQRCodeFeature = ciImage.qrCodeFeature else {Swift.print("QRLib.QRUtil.qrCode() - Unable to get CIQRCodeFeature");return nil}
      guard let messageString:String = feature.messageString else {Swift.print("QRLib.QRUtil.qrCode() - Unable to get messageString");return nil}
      return messageString
   }
}
/**
 * Type
 */
extension QRStringUtil{
   public typealias StringAndFrame = (qrStr: String?, qrFrame: CGRect)
   public typealias DataAndFrame = (qrData: Data?, qrFrame: CGRect)
}
