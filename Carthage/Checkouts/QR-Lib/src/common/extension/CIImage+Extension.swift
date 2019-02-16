#if os(iOS)
import UIKit
#elseif os(macOS)
import Cocoa
#endif
/**
 * CIImage extension
 */
extension CIImage{
   /**
    * Returns raw data from a qr
    */
   var qrData:Data?{
      guard let feature:CIQRCodeFeature = self.qrCodeFeature else {Swift.print("QRLib.QRUtil.qrCode() - Unable to get CIQRCodeFeature");return nil}
      guard let data:Data = feature.data else {Swift.print("err");return nil}//errorCorrectedPayload
      return data
   }
   /**
    * qrCodeFeature
    */
   var qrCodeFeature:CIQRCodeFeature? {
      guard let detector:CIDetector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh]) else {Swift.print("CIImage - unable to create detector");return nil}
      let features:[CIFeature] = detector.features(in: self)
      guard let feature:CIQRCodeFeature = (features.first { $0 is CIQRCodeFeature } as? CIQRCodeFeature) else {Swift.print("CIImage - Unable to get CIQRCodeFeature");return nil}
      return feature
   }
}
/**
 * CIQRCodeFeature extension
 */
extension CIQRCodeFeature{
   /**
    * Returns raw data from a qr
    */
   var data: Data? {
      guard let data:Data = self.symbolDescriptor?.data else {Swift.print("Unable to get data from qrcode");return nil}
      return data
   }
}
/**
 * CIQRCodeDescriptor extension
 */
extension CIQRCodeDescriptor {
   /**
    * Returns raw data from a qr
    */
   var data: Data {
      let errorCorrectedPayload:Data = self.errorCorrectedPayload
      let data:Data = Data(bytes: zip(errorCorrectedPayload.advanced(by: 2),  errorCorrectedPayload.advanced(by: 3)).map { (byte1, byte2) in
         return byte1 << 4 | byte2 >> 4
      })
      return data
   }
}
