import Foundation
/**
 * Getter
 */
extension MonoRep {
   /**
    * Convenience
    */
   var size: Size { .init(width, height) }
   /**
    * Amount of pixels MonotoneImage can hold
    * - Note: used by Colorizer.colorize
    */
   var capacity: Int { self.width * self.height }
}
