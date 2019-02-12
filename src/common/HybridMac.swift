#if os(macOS)
import Cocoa
#endif
/**
 * This makes the code cross platform
 * - Note: by encapsulating it inside an extension we avoid creating a global typalias Image
 */
#if os(macOS)
public typealias Image = NSImage
public typealias Color = NSColor
#endif
