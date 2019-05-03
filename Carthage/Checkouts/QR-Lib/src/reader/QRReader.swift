import Foundation
/**
 * - Description: Image 👉 Data
 */
public final class QRReader {
   /**
    * Returns data
    * - Caution: ⚠️️⚠️️⚠️️ Make sure you fill up the Data to the exact max allowed bytes in the qrVersion you are using, or else white-space bytes will be added and converting back to utf8 gets trickier
    */
   public static func data(ciImage: CIImage) throws -> Data {
      guard let data: Data = try? ciImage.qrData() else { throw ("QRStringUtil.qrCode - unable to get qrData from ciImage") }//errorCorrectedPayload
      return data
   }
   /**
    * Returns data + frame (New)
    * - Caution: ⚠️️⚠️️⚠️️ Make sure you fill up the Data to the exact max allowed bytes in the qrVersion you are using, or else white-space bytes will be added and converting back to utf8 gets trickier
    */
   public static func dataAndFrame(ciImage: CIImage) throws -> DataAndFrame {
      do {
         let feature: CIQRCodeFeature = try ciImage.qrCodeFeature()
         guard let data: Data = try? feature.data() else { throw ("QRStringUtil.qrCode - unable to get qrData from ciImage") }
         let qrFrame: CGRect = .init(origin: feature.topLeft, size: feature.bounds.size)
         return (qrData:data, qrFrame: qrFrame)
      } catch {
         throw ("QRStringUtil:qrCode() -> DataAndFrame - Unable to get qrCodeFeature \(error.localizedDescription)")
      }
   }
}
