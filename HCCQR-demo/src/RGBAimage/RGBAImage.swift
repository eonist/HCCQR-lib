import UIKit
/**
 * TODO: ⚠️️ You have to dealocate the memory at some point, see: https://stackoverflow.com/questions/34750166/how-to-use-unsafemutablebufferpointer
 */
public struct RGBAImage {
    public var pixels:UnsafeMutableBufferPointer<Pixel>
    public var width:Int
    public var height:Int
   /**
    * Creates a copy if you already have the pixels and width height
    */
   public init(pixels:UnsafeMutableBufferPointer<Pixel>, width:Int, height:Int)  {
      self.pixels = pixels
      self.width = width
      self.height = height
   }
}
