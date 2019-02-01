import UIKit
import QRLibIOS
import Vision

class ImageScanner{
   /**
    * scanImage (String)
    * - Parameter size: This isnt that important, lower size ay mean faster generation (QRCodes are generated in units, not in pixels)
    */
   @discardableResult
   static func scanImage(string:String, size:CGSize, ecLevel:ECLevel, scanComplete:@escaping ScanComplete) -> UIImage?{
      guard let image:UIImage = QRUtil.qrImage(str: string, size: size,ecLevel: ecLevel) else {return nil}
      scanImage(image: image, scanComplete: scanComplete)
      return image
   }
   /**
    * scanImage (UIImage)
    */
   static func scanImage(image: UIImage, scanComplete:@escaping ScanComplete) {
      guard let cgImage = image.cgImage() else {scanComplete(nil);Swift.print("Unable to convert UIImage to CGImage");return}
      let barcodeRequest:VNRequest = VNDetectBarcodesRequest.init{ (request:VNRequest, error:Error?) in/*Create a call-back*/
         handleCompletion(completion: (request,error), scanComplete:scanComplete)
      }
      let handler = VNImageRequestHandler(cgImage: cgImage, options: [.properties : ""])/*Setup the process*/
      guard let _ = try? handler.perform([barcodeRequest]) else {/*Init the process*/
         scanComplete(nil)
         Swift.print("Could not perform barcode-request!")
         return
      }
   }
}
/**
 * Hander
 */
extension ImageScanner{
   /**
    * Completion handler for barcode request
    * - Note: let content = String(data: desc.errorCorrectedPayload, encoding: .utf8)//the payload
    * - Note: Swift.print("Payload: \(String(describing: content))")
    * - Note: FIXME: This currently returns nil. I did not find any docs on how to encode the data properly so far.
    * - Note: https://stackoverflow.com/questions/44683242/vision-framework-barcode-detection-for-ios-11
    */
   fileprivate static func handleCompletion(completion:VNBarCodeRequestCompletion, scanComplete:ScanComplete){
      //      Swift.print("Barcode observation")
      guard let results = completion.request.results else { scanComplete(nil);Swift.print("No results found.");return  }
      //      print("Number of results found: \(results.count)")
      guard let firstResult = results.first else {scanComplete(nil);return Swift.print("NO result in results")}// Loop through the found results
      guard let barcode:VNBarcodeObservation = firstResult as? VNBarcodeObservation else {scanComplete(nil);Swift.print("no barcode in result");return }/*Cast the result to a barcode-observation*/
      guard let payload = barcode.payloadStringValue else { scanComplete(nil);Swift.print("has no payload"); return  }
      _ = payload
//      Swift.print("Payload: \(payload)")
//      Swift.print("Symbology: \(barcode.symbology.rawValue)")/*Print barcode-values*/
      guard let desc = barcode.barcodeDescriptor as? CIQRCodeDescriptor else { scanComplete(nil);Swift.print("unable to get description from barcode");return }
//      let errorCorrectionLevel:String = debugCorretionLevel(errorCorrectionLevel: desc.errorCorrectionLevel)
//      Swift.print("Error-Correction-Level: \(errorCorrectionLevel)")/*QR Codes support four levels of Reed-Solomon error correction, in increasing error correction capability: L, M, Q, and H.*/
//      Swift.print("Symbol-Version: \(desc.symbolVersion) 👈  ")/*QR Codes are square. ISO/IEC 18004 defines versions from 1 to 40, where a higher symbol version indicates a larger data carrying capacity. This field is required in order to properly interpret the error corrected payload.*/
//      Swift.print("desc.maskPattern:  \(desc.maskPattern)")/*0 to 7, QR Codes support eight data mask patterns, which are used to avoid large black or large white areas inside the symbol body. Valid values range from 0 to 7.*/
      scanComplete(desc.symbolVersion)
   }
}
/**
 * Type
 */
extension ImageScanner{
   fileprivate typealias VNBarCodeRequestCompletion = (request:VNRequest, error:Error?)
   /**
    * - Abstract: QR Codes are square. ISO/IEC 18004 defines versions from 1 to 40, where a higher symbol version indicates a larger data carrying capacity. This field is required in order to properly interpret the error corrected payload.
    */
   typealias ScanComplete = (_ symbolVersion:Int?) -> Void
}
/**
 * Helper
 */
extension ImageScanner{
   /**
    * Gets errCorrectionLevel
    */
   fileprivate static func debugCorretionLevel(errorCorrectionLevel: CIQRCodeDescriptor.ErrorCorrectionLevel) -> String{
      let errCorrectionLevel:String = {
         switch errorCorrectionLevel {
         case CIQRCodeDescriptor.ErrorCorrectionLevel.levelL: return "L"
         case CIQRCodeDescriptor.ErrorCorrectionLevel.levelM: return "M"
         case CIQRCodeDescriptor.ErrorCorrectionLevel.levelQ: return "Q"
         case CIQRCodeDescriptor.ErrorCorrectionLevel.levelH: return "H"
         }
      }()
      return errCorrectionLevel
   }
}
