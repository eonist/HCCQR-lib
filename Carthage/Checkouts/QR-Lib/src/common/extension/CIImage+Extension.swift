#if os(iOS)
import UIKit
#elseif os(macOS)
import Cocoa
#endif
/**
 * CIImage extension
 */
public extension CIImage{
   /**
    * Returns raw data from a qr
    */
   func qrData() throws -> Data {
      guard let feature:CIQRCodeFeature = try? self.qrCodeFeature() else  { throw ("QRLib.CIImage.qrData - Unable to get CIQRCodeFeature") }
      guard let data:Data = try? feature.data() else {throw ("qrData - err") }//errorCorrectedPayload
      return data
   }
//   static var device:MTLDevice?
//   public static var detector:CIDetector?
   /**
    * qrCodeFeature
    * - Caution: ⚠️️ you can only spin up 60 or so detectors before things fall apart. Make sure this is called on the main thread. Or do more tests, CIDetector can work as a singlton for instance
    */
   func qrCodeFeature() throws -> CIQRCodeFeature {
      guard let ciImage:CIImage = Optional(self) else {throw ("QRLib.CIImage.qrCodeFeature - self is optional") }
      guard let detector:CIDetector =  CIDetector.init(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh]) else {throw ("QRLib.CIImage.qrCodeFeature - unable to create detector  ") }
      guard let features:[CIFeature] = Optional(detector.features(in: ciImage)) else {throw ("QRLib.CIImage.qrCodeFeature - features is optional") }
      let optionalFeature:CIQRCodeFeature? = features.first { $0 is CIQRCodeFeature } as? CIQRCodeFeature
      guard let feature:CIQRCodeFeature = optionalFeature else {throw ("QRLib.CIImage.qrCodeFeature - Unable to get CIQRCodeFeature") }
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
   func data() throws -> Data {//TODO: ⚠️️ revert to optional, throw only if there is sub throws or more than one type of nil,or not, description msg is nice
      guard let data:Data = self.symbolDescriptor?.data else { throw ("QRLib.CIQRCodeFeature.data - Unable to get symbolDescriptor or data from qrcode feature.symbolDescriptor?.symbolVersion\(String(describing: self.symbolDescriptor?.symbolVersion)) self.symbolDescriptor?.errorCorrectionLevel:\(String(describing: self.symbolDescriptor?.errorCorrectionLevel))") }
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
