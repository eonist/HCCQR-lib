#if os(iOS)
import UIKit
#elseif os(macOS)
import Cocoa
#endif
/**
 * This makes the code cross platform
 * - Note: by encapsulating it inside an extension we avoid creating a global typalias Image
 */
extension RGBAImage{//should this be public,internal?
   #if os(iOS)
   public typealias Image = UIImage
   #elseif os(macOS)
   public typealias Image = NSImage
   #endif
}
/**
 * TODO: ⚠️️ You have to dealocate the memory at some point, see: https://stackoverflow.com/questions/34750166/how-to-use-unsafemutablebufferpointer
 */
internal struct RGBAImage {//TODO: ⚠️️ this should really be called ARGBImage
    internal var pixels:UnsafeMutableBufferPointer<PixelData>
    internal var width:Int
    internal var height:Int
   /**
    * Creates a copy if you already have the pixels and width height
    */
   internal init(pixels:UnsafeMutableBufferPointer<PixelData>, width:Int, height:Int)  {
      self.pixels = pixels
      self.width = width
      self.height = height
   }
}

