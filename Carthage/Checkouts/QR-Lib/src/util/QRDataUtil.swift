import Foundation
/**
 * - Description: Image 👉 Data
 * - TODO: ⚠️️ rename to QRReader
 */
final public class QRDataUtil{
   #if os(iOS)
   /**
    * Returns a string for an UIImage with a QRCode (⚠️️ New ⚠️️)
    * ## Examples:
    * - iOS provides descriptor in the cameraCapture call
    * qrCode(descriptor: descriptor)//Data()
    * - TODO: ⚠️️ rename to data(image)
    */
   public static func qrCode(descriptor:CIQRCodeDescriptor) -> Data {
      return descriptor.data
   }
   #endif
   /**
    * Returns data (New)
    * - TODO: ⚠️️ rename to data(image)
    * - Caution: ⚠️️⚠️️⚠️️ Make sure you fill up the Data to the exact max allowed bytes in the qrVersion you are using, or else white-space bytes will be added and converting back to utf8 gets trickier
    */
   public static func qrCode(ciImage:CIImage) throws -> Data {
      guard let data:Data = try? ciImage.qrData() else {throw ("QRStringUtil.qrCode - unable to get qrData from ciImage") }//errorCorrectedPayload
      return data
   }
   /**
    * Returns data + frame (New)
    * - TODO: ⚠️️ rename to dataAndFrame(image)
    * - Caution: ⚠️️⚠️️⚠️️ Make sure you fill up the Data to the exact max allowed bytes in the qrVersion you are using, or else white-space bytes will be added and converting back to utf8 gets trickier
    */
   public static func qrCode(ciImage: CIImage) throws -> DataAndFrame {
      guard let feature:CIQRCodeFeature = try? ciImage.qrCodeFeature() else {throw ("QRStringUtil:qrCode() -> DataAndFrame - Unable to get qrCodeFeature") }
      guard let data:Data = try? feature.data() else {throw ("QRStringUtil.qrCode - unable to get qrData from ciImage") }
      let qrFrame:CGRect = .init(origin: feature.topLeft, size: feature.bounds.size)
      return (qrData:data, qrFrame: qrFrame)
   }
}
/**
 * Type
 */
extension QRDataUtil{
   public typealias DataAndFrame = (qrData: Data, qrFrame: CGRect)
}
