#if os(iOS)
import UIKit
#elseif os(macOS)
import Cocoa
#endif
/**
 * This makes the code cross platform
 * - Note: by encapsulating it inside an extension we avoid creating a global typalias Image
 */
//extension RGBAImage{//should this be public,internal?
   #if os(iOS)
   public typealias Image = UIImage
   #elseif os(macOS)
   public typealias Image = NSImage
   #endif
//}
