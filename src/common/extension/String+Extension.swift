
import Foundation

extension String: Error {}/*Enables you to throw a string*/

extension String: LocalizedError {/*Adds error.localizedDescription to Error instances*/
   public var errorDescription: String? { return self }
//   public var description: String { return self.localizedDescription ?? "" }
}
