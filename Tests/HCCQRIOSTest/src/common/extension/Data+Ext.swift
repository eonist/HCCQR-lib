import Foundation

extension Data {
   /**
    * Returns string for Data (utf8)
    */
   var stringUTF8: String? { // Convenience method
      return String(data: self, encoding: .utf8)
   }
}
