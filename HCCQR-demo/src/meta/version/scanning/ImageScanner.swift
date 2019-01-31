import UIKit
import Vision

class ImageScanner{
   /**
    * scanImage
    */
   static func scanImage(image: UIImage, scanCompletion:@escaping ScanComplete) {
      guard let cgImage = image.cgImage() else {scanCompletion(nil);Swift.print("Unable to convert UIImage to CGImage");return}
      let barcodeRequest:VNRequest = VNDetectBarcodesRequest.init{ (request:VNRequest, error:Error?) in/*Create a call-back*/
         handleCompletion(completion: (request,error), scanCompletion:scanCompletion)
      }
      let handler = VNImageRequestHandler(cgImage: cgImage, options: [.properties : ""])/*Setup the process*/
      guard let _ = try? handler.perform([barcodeRequest]) else {/*Init the process*/
         scanCompletion(nil)
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
   fileprivate static func handleCompletion(completion:VNBarCodeRequestCompletion, scanCompletion:ScanComplete){
      //      Swift.print("Barcode observation")
      guard let results = completion.request.results else { scanCompletion(nil);Swift.print("No results found.");return  }
      //      print("Number of results found: \(results.count)")
      guard let firstResult = results.first else {scanCompletion(nil);return Swift.print("NO result in results")}// Loop through the found results
      guard let barcode:VNBarcodeObservation = firstResult as? VNBarcodeObservation else {scanCompletion(nil);Swift.print("no barcode in result");return }/*Cast the result to a barcode-observation*/
      guard let payload = barcode.payloadStringValue else { scanCompletion(nil);Swift.print("has no payload"); return  }
      _ = payload
//      Swift.print("Payload: \(payload)")
//      Swift.print("Symbology: \(barcode.symbology.rawValue)")/*Print barcode-values*/
      guard let desc = barcode.barcodeDescriptor as? CIQRCodeDescriptor else { scanCompletion(nil);Swift.print("unable to get description from barcode");return }
//      let errorCorrectionLevel:String = debugCorretionLevel(errorCorrectionLevel: desc.errorCorrectionLevel)
//      Swift.print("Error-Correction-Level: \(errorCorrectionLevel)")/*QR Codes support four levels of Reed-Solomon error correction, in increasing error correction capability: L, M, Q, and H.*/
//      Swift.print("Symbol-Version: \(desc.symbolVersion) 👈  ")/*QR Codes are square. ISO/IEC 18004 defines versions from 1 to 40, where a higher symbol version indicates a larger data carrying capacity. This field is required in order to properly interpret the error corrected payload.*/
//      Swift.print("desc.maskPattern:  \(desc.maskPattern)")/*0 to 7, QR Codes support eight data mask patterns, which are used to avoid large black or large white areas inside the symbol body. Valid values range from 0 to 7.*/
      scanCompletion(desc.symbolVersion)
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
