#if os(iOS)
import UIKit
/**
 * This makes the code cross platform
 * - Note: by encapsulating it inside an extension we avoid creating a global typalias Image
 */
public typealias Image = UIImage
public typealias Color = UIColor
#endif
