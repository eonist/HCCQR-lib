import Foundation
import CoreImage

enum ReadError: Error {
   case unableToExtractQRData(msg: String, ciImage: CIImage) // unable to extract data from QRImages
   case unableToSplitRGBAImage // unable to split rgbaImage
   case unableToExtractRGBAImageFromCVBuffer // unable to extract RGBAImage from CVBuffer
}
