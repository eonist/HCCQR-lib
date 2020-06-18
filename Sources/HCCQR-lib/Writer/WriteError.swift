import Foundation

public enum WriteError: Error {
   case unableToCreateRGBAImage(errMSG: String)
   case unableToConvertRGBAToImage // Colorize.colorize() - Unable to convert to UIImage
   case unableToCreateCIImage
   case unableToCreateColorizedImage
}
