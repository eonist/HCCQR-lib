// 🏀
   // try to figure out faster ways to do the image -> pixel code
   // maybe you can do 1x <-> 2x retina more optimized by skipping every 2nd pixel ?
   // split up the colorize method
   // write pseudo-code for lifting, imprinting spessific areas of intrest 👈 👈 👈
import UIKit
import QRLibIOS
import Vision

class AimMarkTestView:UIView{
   /**
    * Initiate
    * - Note: PrimaryAlignMarks are relative in size to the qrimg size
    * - Note: 270 char-count seems to be the max count for the minimum readable align mark
    */
   override init(frame: CGRect) {
      super.init(frame: frame)
//      let string:String = String(Array.init(repeating: "a", count: 243))
      let string:String = String.init(repeating: "9", count: Int(38)) + "5"//+ "z"//270
      
      
      //🏀
         //use the regexp from that github website to calculate mode,
         //or use code from zxing  🚫
            //mess around with the zxing code a bit to try and derive the calculateVersion method 🚫
         //when you have mode, create your own table that works with apple qr creator, by looping over different amounts of characters etc
         //use this table to calculate version from inputString
            //Create a table format (pseudo) 👈
            //write a table populator (pseudo) 👈
            //clean up the Vision.version handler code into its own class 👈
      
      
//      let utf8Count:Int = string.utf8.count
//      guard let asciiData:Data = string.asciiData else {fatalError("no data")}
//      guard let asciiString:String = asciiData.stringASCII else {fatalError("no string")}
//      Swift.print("asciiString:  \(asciiString)")
//      Swift.print("string.count:  \(string.count)")
      let ascii = string.asciiString
      Swift.print("ascii:  \(ascii)")
      Swift.print("ascii.count:  \(ascii.count)")
//      let nsStr = NSString.init(string: string)
//      let utf8Arr:[Int] = string.utf8.map{String(Int8($0)).count}
//      Swift.print("utf8Arr:  \(utf8Arr)")
//      let utf8ByteCount:Int = string.utf8.map{String(Int8($0)).count}.reduce(0){$0 + $1}
//      Swift.print("utf8ByteCount:  \(utf8ByteCount)")
      

      
//      let data:Data = string.data(using:.utf8)! //as NSData
//      Swift.print("data.bytes:  \(data.length)")
//      var values = [UInt8](repeating:0, count:data.count)
//      data.copyBytes(to: &values, count: data.count)
//      Swift.print("values:  \(values)")
//      Swift.print("values.count:  \(values.count)")
//      Swift.print("utf8Count:  \(utf8Count)")
//      Swift.print("7:  \("7777".utf8CString.count)")
//      Swift.print("x:  \("xuab".utf8CString.count)")
//      Swift.print("🎉:  \("🎉".utf8CString.count)")
//      Swift.print("string.utf16.count:  \(string.utf16.count)")
//      let string:String = String(Array.init(repeating: "a", count: 300))
      guard let image:UIImage = QRUtil.qrImage(str: string, size: .init(width:375,height:375)) else {fatalError("err")}
      let imageView:UIImageView = UIImageView.init(image: image)
      self.addSubview(imageView)
      /**/
      let alignMarkImgView:UIImageView = AlignMarkUtil.alignMarkGraphic(qrImgSize: /*.init(width: 300, height: 300)*/image.size, strCount: string.count)
      addSubview(alignMarkImgView)
      
      guard let cgImage = image.cgImage() else {fatalError("cg img 🤔")}
      scanImage(cgImage: cgImage)
//      alignMarkImgView.frame.origin.y = 375
   }
   /**
    * scanImage
    */
   private func scanImage(cgImage: CGImage) {
      let barcodeRequest = VNDetectBarcodesRequest(completionHandler: { request, error in
         self.reportResults(results: request.results)
      })
      
      let handler = VNImageRequestHandler(cgImage: cgImage, options: [.properties : ""])
      
      guard let _ = try? handler.perform([barcodeRequest]) else {
         return print("Could not perform barcode-request!")
      }
   }
   /**
    * reportResults
    */
   private func reportResults(results: [Any]?) {
      // Loop through the found results
      print("Barcode observation")
      
      guard let results = results else {
         return print("No results found.")
      }
      
      print("Number of results found: \(results.count)")
      
      for result in results {
         
         // Cast the result to a barcode-observation
         if let barcode:VNBarcodeObservation = result as? VNBarcodeObservation {
            
            if let payload = barcode.payloadStringValue {
               print("Payload: \(payload)")
            }
            
            // Print barcode-values
            print("Symbology: \(barcode.symbology.rawValue)")
            
            if let desc = barcode.barcodeDescriptor as? CIQRCodeDescriptor {
//               let content = String(data: desc.errorCorrectedPayload, encoding: .utf8)//the payload
               // FIXME: This currently returns nil. I did not find any docs on how to encode the data properly so far.
               // https://stackoverflow.com/questions/44683242/vision-framework-barcode-detection-for-ios-11
//               Swift.print("Payload: \(String(describing: content))")
               let errorCorrectionLevel:String = {
                  switch desc.errorCorrectionLevel {
                     case CIQRCodeDescriptor.ErrorCorrectionLevel.levelL: return "L"
                     case CIQRCodeDescriptor.ErrorCorrectionLevel.levelM: return "M"
                     case CIQRCodeDescriptor.ErrorCorrectionLevel.levelQ: return "Q"
                     case CIQRCodeDescriptor.ErrorCorrectionLevel.levelH: return "H"
                  }
               }()
               Swift.print("Error-Correction-Level: \(errorCorrectionLevel)")//QR Codes support four levels of Reed-Solomon error correction, in increasing error correction capability: L, M, Q, and H.
               Swift.print("Symbol-Version: \(desc.symbolVersion)✅  ")//QR Codes are square. ISO/IEC 18004 defines versions from 1 to 40, where a higher symbol version indicates a larger data carrying capacity. This field is required in order to properly interpret the error corrected payload.
               Swift.print("desc.maskPattern:  \(desc.maskPattern)")// 0 to 7, QR Codes support eight data mask patterns, which are used to avoid large black or large white areas inside the symbol body. Valid values range from 0 to 7.
               
            }
         }
      }
   }
   /**
    * Boilerplate
    */
   required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   //create QR image
   //try a few different sizes etc
   //create the Aim code
   //try to layer it on top the different sizes etc
}
