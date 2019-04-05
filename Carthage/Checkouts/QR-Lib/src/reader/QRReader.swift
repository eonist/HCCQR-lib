import Foundation
/**
 * - Description: Image 👉 Data
 */
final public class QRReader{
   /**
    * Returns data
    * - Caution: ⚠️️⚠️️⚠️️ Make sure you fill up the Data to the exact max allowed bytes in the qrVersion you are using, or else white-space bytes will be added and converting back to utf8 gets trickier
    */
   public static func data(ciImage:CIImage) throws -> Data {
      guard let data:Data = try? ciImage.qrData() else {throw ("QRStringUtil.qrCode - unable to get qrData from ciImage") }//errorCorrectedPayload
      return data
   }
   /**
    * Data and quad
    */
   public static func dataAndQuad(ciImage:CIImage) throws -> DataAndQuad {
      do {
         let dataAndFeature:DataAndFeature = try QRReader.dataAndFeature(ciImage:ciImage)
         let feature = dataAndFeature.feature
         let quad:Quad = (p1:feature.topLeft,p2:feature.topRight,p3:feature.bottomLeft,p4:feature.bottomRight)
         return (qrData:dataAndFeature.qrData, quad: quad)
      }catch {
         throw ("QRStringUtil:qrCode() -> dataAndQuad \(error.localizedDescription)")
      }
   }
   /**
    * Data and frame
    */
   public static func dataAndFrame(ciImage:CIImage) throws -> DataAndFrame {
      do {
         let dataAndFeature:DataAndFeature = try QRReader.dataAndFeature(ciImage:ciImage)
         let qrFrame:CGRect = .init(origin: dataAndFeature.feature.topLeft, size: dataAndFeature.feature.bounds.size)
         return (qrData:dataAndFeature.qrData, qrFrame: qrFrame)
      }catch {
         throw ("QRStringUtil:qrCode() -> DataAndFrame \(error.localizedDescription)")
      }
   }
}
/**
 * Helper
 */
extension QRReader{
   /**
    * Returns data + frame (New)
    * - Caution: ⚠️️⚠️️⚠️️ Make sure you fill up the Data to the exact max allowed bytes in the qrVersion you are using, or else white-space bytes will be added and converting back to utf8 gets trickier
    */
   private static func dataAndFeature(ciImage:CIImage) throws -> DataAndFeature {
      do {
         let feature:CIQRCodeFeature = try ciImage.qrCodeFeature()
         let data:Data = try feature.data()
         return (qrData:data, feature: feature)
      }catch {
         throw ("QRStringUtil:qrCode() -> dataAndFeature \(error.localizedDescription)")
      }
   }
}
