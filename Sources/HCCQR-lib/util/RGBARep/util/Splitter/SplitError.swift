import Foundation

public enum SplitError: Error {
   case unableToCreateRGBAImgs(msg: String) // \(result.errorStr)
   case noQRImg(i: Int)
}
