import Foundation

extension String: Error {}/*Enables you to throw a string*/

extension String: LocalizedError {/*Adds error.localizedDescription to Error instances*/
   public var errorDescription: String? { return self }
}
