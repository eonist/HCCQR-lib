#if os(macOS)
import Cocoa

/**
 * This makes the code cross platform
 * - Note: by encapsulating it inside an extension we avoid creating a global typalias Image
 */

public typealias Image = NSImage
public typealias Color = NSColor
#endif


