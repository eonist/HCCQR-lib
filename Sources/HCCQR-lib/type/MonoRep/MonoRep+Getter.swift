import Foundation
/**
 * Getter
 */
extension MonoRep {
   /**
    * Convenience
    */
   var size: BufferSize { .init(width, height) }
   /**
    * Amount of pixels MonotoneImage can hold
    * - Note: used by Colorizer.colorize
    */
   var capacity: Int { self.width * self.height }
}
