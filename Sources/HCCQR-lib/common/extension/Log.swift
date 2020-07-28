import Foundation

public class Log {}

extension Log {
   public static var isDebug: Bool = false
   /**
    * log
    */
   static func log(_ str: String) {
      #if DEBUG
      if isDebug {
         Swift.print(str)
      }
      #endif
   }
}
