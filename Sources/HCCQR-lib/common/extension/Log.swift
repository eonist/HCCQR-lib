import Foundation

public class Log {}

extension Log {
   /**
    * Toggle debug on and off
    * - Note: This can be set from other repos as well
    */
   public static var isDebug: Bool = true
   /**
    * log
    */
   static func log(_ str: String) {
      #if DEBUG // will always turn of printing in release etc
      if isDebug {
         Swift.print(str)
      }
      #endif
   }
}
