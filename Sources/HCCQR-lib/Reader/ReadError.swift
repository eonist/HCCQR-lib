import Foundation
import CoreImage

public enum ReadError: Error {
   /**
    * - Parameters:
    *   - msg: the error message from previous called method
    *   - ciImage: the qrImage that the lib was unable to extract data from
    */
   case unableToExtractQRData(msg: String, ciImage: CIImage) // unable to extract data from QRImages
   case unableToSplit(errMSG: String)
   case unableToExtractRGBAImageFromCVBuffer // unable to extract RGBAImage from CVBuffer
   case unableToGetDataOrQuad // cvimagebuffer error
   case unableToGetDataAndImages(msg: String) // cvimagebuffer error
}
