#if os(iOS)
import UIKit
#elseif os(macOS)
import Cocoa
#endif
/**
 * CIImage extension
 */
extension CIImage {
   /**
    * Returns raw data from a qr
    */
   public func qrData() throws -> Data {
      do {
         let feature: CIQRCodeFeature = try self.qrCodeFeature()
         return try feature.data()
      } catch {
         throw ("QRLib.CIImage.qrData - \(error.localizedDescription)")
      }
   }
   /**
    * symbolVersion
    */
   public func symbolVersion() throws -> Int {
      do {
         let feature: CIQRCodeFeature = try self.qrCodeFeature()
         return try feature.symbolVersion()
      } catch {
         throw ("QRLib.CIImage.symbolVersion - \(error.localizedDescription)")
      }
   }
   /**
    * ecLevel
    */
   public func ecLevel() throws -> CIQRCodeDescriptor.ErrorCorrectionLevel {
      do {
         let feature: CIQRCodeFeature = try self.qrCodeFeature()
         return try feature.ecLevel()
      } catch {
         throw ("QRLib.CIImage.ecLevel - \(error.localizedDescription)")
      }
   }
   /**
    * qrCodeFeature
    * - Caution: ⚠️️ you can only spin up 60 or so detectors before things fall apart. Make sure this is called on the main thread. Or do more tests, CIDetector can work as a singlton for instance
    */
   public func qrCodeFeature() throws -> CIQRCodeFeature {
      guard let ciImage: CIImage = Optional(self) else { throw ("QRLib.CIImage.qrCodeFeature - self is optional") }
      guard let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh]) else { throw ("QRLib.CIImage.qrCodeFeature - unable to create detector  ") }
      guard let features: [CIFeature] = Optional(detector.features(in: ciImage)) else { throw ("QRLib.CIImage.qrCodeFeature - features is optional") }
      let optionalFeature: CIQRCodeFeature? = features.first { $0 is CIQRCodeFeature } as? CIQRCodeFeature
      guard let feature: CIQRCodeFeature = optionalFeature else { throw ("QRLib.CIImage.qrCodeFeature - Unable to get CIQRCodeFeature") }
      return feature
   }
}
/**
 * CIQRCodeFeature extension
 */
extension CIQRCodeFeature {
   /**
    * Returns raw data from a qr
    * - Reference: https://stackoverflow.com/questions/44683242/vision-framework-barcode-detection-for-ios-11
    * - Important: ⚠️️ qr version 9 has problems with storing raw byte data.
    * - Fixme: ⚠️️ try to figure out why qrv9 has problems
    */
   func data() throws -> Data {
      guard let symbolDescriptor: CIQRCodeDescriptor = self.symbolDescriptor else { throw ("QRLib.CIQRCodeFeature.data - Unable to get symbolDescriptor or data from qrcode feature.symbolDescriptor?.symbolVersion\(String(describing: self.symbolDescriptor?.symbolVersion)) self.symbolDescriptor?.errorCorrectionLevel:\(String(describing: self.symbolDescriptor?.errorCorrectionLevel))") }
      if symbolDescriptor.symbolVersion >= 10 {
          return symbolDescriptor.data
      } else if symbolDescriptor.symbolVersion < 9 {
         guard let data = symbolDescriptor.bytes else { throw "QRLib.CIQRCodeFeature.data - Unable to get bytes" }
         return data
      } else {
         throw "QRLib.CIQRCodeFeature.data symbolDescriptor.symbolVersion\(symbolDescriptor.symbolVersion) not supported"
      }
   }
   /**
    * symbolVersion
    */
   func symbolVersion() throws -> Int {
      guard let symbolDescriptor: CIQRCodeDescriptor = self.symbolDescriptor else { throw ("QRLib.CIQRCodeFeature.data - Unable to get symbolDescriptor or data from qrcode feature.symbolDescriptor?.symbolVersion\(String(describing: self.symbolDescriptor?.symbolVersion)) self.symbolDescriptor?.errorCorrectionLevel:\(String(describing: self.symbolDescriptor?.errorCorrectionLevel))") }
      return symbolDescriptor.symbolVersion
   }
   /**
    * ecLevel
    */
   func ecLevel() throws -> CIQRCodeDescriptor.ErrorCorrectionLevel {
      guard let symbolDescriptor: CIQRCodeDescriptor = self.symbolDescriptor else { throw ("QRLib.CIQRCodeFeature.data - Unable to get symbolDescriptor or data from qrcode feature.symbolDescriptor?.symbolVersion\(String(describing: self.symbolDescriptor?.symbolVersion)) self.symbolDescriptor?.errorCorrectionLevel:\(String(describing: self.symbolDescriptor?.errorCorrectionLevel))") }
      return symbolDescriptor.errorCorrectionLevel
   }
}
/**
 * CIQRCodeDescriptor extension
 */
extension CIQRCodeDescriptor {
   /**
    * Returns raw data from a qr
    * - Reference: https://stackoverflow.com/questions/44683242/vision-framework-barcode-detection-for-ios-11
    */
   var data: Data {
      let errorCorrectedPayload: Data = self.errorCorrectedPayload
      let data: Data = .init(zip(errorCorrectedPayload.advanced(by: 2), errorCorrectedPayload.advanced(by: 3)).map { byte1, byte2 in
         byte1 << 4 | byte2 >> 4
      })
      return data
   }
}
extension CIQRCodeDescriptor {
   /**
    * Fixme: ⚠️️ Clean this up a bit
    */
   var bytes: Data? {
      return errorCorrectedPayload.withUnsafeBytes { (pointer: UnsafePointer<UInt8>) in
         var cursor = pointer
         let representation = (cursor.pointee >> 4) & 0x0f
         guard representation == 4 /* byte encoding */ else { return nil }
         var curCount = (cursor.pointee << 4) & 0xf0
         cursor = cursor.successor()
         curCount |= (cursor.pointee >> 4) & 0x0f
         var out = Data(count: Int(curCount))
         guard curCount > 0 else { return out }
         var prev = (cursor.pointee << 4) & 0xf0
         for idx in 2...errorCorrectedPayload.count {
            if (idx - 2) == curCount { break }
            let cursor = pointer.advanced(by: Int(idx))
            let byte = cursor.pointee
            let current = prev | ((byte >> 4) & 0x0f)
            out[idx - 2] = current
            prev = (cursor.pointee << 4) & 0xf0
         }
         return out
      }
   }
}
