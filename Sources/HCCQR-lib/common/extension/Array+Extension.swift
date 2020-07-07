import Foundation
/**
 * Asserter
 */
extension Array where Element == Optional<Any> {
   /**
    * Asserts if array has nil values
    * ## Examples:
    * [0,nil,1,2].hasNil // true
    * [0,1,2].hasNil // false
    */
   var hasNil: Bool { self.contains(where: { $0 == nil }) }
}
