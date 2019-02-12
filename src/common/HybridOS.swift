#if os(iOS)
import UIKit
//#elseif os(macOS)
////import Cocoa
//#endif
/**
 * This makes the code cross platform
 * - Note: by encapsulating it inside an extension we avoid creating a global typalias Image
 */
public typealias Image = UIImage
public typealias Color = UIColor
//#elseif os(macOS)
//public typealias Image = NSImage
//public typealias Color = NSColor
#endif
