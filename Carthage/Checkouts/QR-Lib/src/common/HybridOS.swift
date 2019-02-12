#if os(iOS)
import UIKit
#elseif os(macOS)
import Cocoa
#endif
/**
 * This makes the code cross platform
 */
#if os(iOS)
public typealias Image = UIImage
#elseif os(macOS)
public typealias Image = NSImage
#endif
