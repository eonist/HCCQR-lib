import Foundation
/**
 * Error
 */
internal enum CGImageErr: Error {
   case unableToCreateCFData
   case unableToCreateCGDataProvider
   case unableToCreateCGImage
}
