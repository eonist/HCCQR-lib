import Foundation

public enum ColorizeError: Error {
   case mismatchbetweenNumOfLayersAndColorMap
   case unableToCreateRGBAImageFromQRImages // err creating RGBAImage from QR CIImages
   case unableToConvertRGBAToImage
}
