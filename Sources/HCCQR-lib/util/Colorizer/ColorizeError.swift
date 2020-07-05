import Foundation

public enum ColorizeError: Error {
   case mismatchbetweenNumOfLayersAndColorPallet
   case unableToCreateRGBAImageFromQRImages // err creating RGBAImage from QR CIImages
   case unableToConvertRGBAToImage
}
