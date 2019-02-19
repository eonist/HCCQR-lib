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
    *
    */
//   func data(onComplete:(_ data:Data?){
//      
//   }
   /**
    * Returns raw data from a qr
    */
   var qrData:Data?{
      guard let feature:CIQRCodeFeature = self.qrCodeFeature else {Swift.print("QRLib.CIImage.qrData - Unable to get CIQRCodeFeature");return nil}
      guard let data:Data = feature.data else {Swift.print("qrData - err");return nil}//errorCorrectedPayload
      return data
   }
//   static var device:MTLDevice?
//   public static var detector:CIDetector?
   /**
    * qrCodeFeature
    */
   var qrCodeFeature:CIQRCodeFeature? {
      guard let ciImage:CIImage = Optional(self) else {Swift.print("QRLib.CIImage.qrCodeFeature - self is optional");return nil}
//      Swift.print("ciImage:  \(ciImage)")
      
//
//
      
//      if CIImage.detector == nil {
//         let ciContext:CIContext = {
//                     if CIImage.device == nil {
//                        CIImage.device = MTLCreateSystemDefaultDevice()
//                     }
//                     if let device:MTLDevice = CIImage.device{
//                        Swift.print("using metal")
//                        return CIContext.init(mtlDevice: device)
//                     } else{
//                        Swift.print("not using metal")
//                        return CIContext.init()
//                     }//{Swift.print("qrCodeFeature() - mtlDevice not ready");return nil}
//
//                  }()
//         let ciContext:CIContext = CIContext.init()
//         DispatchQueue.main.async {
         
//         }
         
//      }
//      Swift.print("CIImage.detector:  \(CIImage.detector != nil ? "✅" : "🚫")")
      guard let detector:CIDetector =  CIDetector.init(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh]) else {Swift.print("QRLib.CIImage.qrCodeFeature - unable to create detector  ");return nil}
//      Swift.print("detector:  \(detector)")
      //      Swift.print("qrCodeFeature")
      guard let features:[CIFeature] = Optional(detector.features(in: ciImage)) else {Swift.print("QRLib.CIImage.qrCodeFeature - features is optional");return nil}
//      Swift.print("features:  \(features.count)")
      let optionalFeature:CIQRCodeFeature? = features.first { $0 is CIQRCodeFeature } as? CIQRCodeFeature
//      Swift.print("optionalFeature:  \(String(describing: optionalFeature))")
      guard let feature:CIQRCodeFeature = optionalFeature else {Swift.print("QRLib.CIImage.qrCodeFeature - Unable to get CIQRCodeFeature");return nil}
//      Swift.print("feature:  \(feature)")
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
      guard let data:Data = self.symbolDescriptor?.data else {Swift.print("QRLib.CIQRCodeFeature.data - Unable to get data from qrcode");return nil}
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
