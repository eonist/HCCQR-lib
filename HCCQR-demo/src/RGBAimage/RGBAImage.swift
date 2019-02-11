import UIKit
/**
 * TODO: ⚠️️ You have to dealocate the memory at some point, see: https://stackoverflow.com/questions/34750166/how-to-use-unsafemutablebufferpointer
 */
public struct RGBAImage {//TODO: ⚠️️ this should really be called ARGBImage
    public var pixels:UnsafeMutableBufferPointer<PixelData>
    public var width:Int
    public var height:Int
   /**
    * Creates a copy if you already have the pixels and width height
    */
   public init(pixels:UnsafeMutableBufferPointer<PixelData>, width:Int, height:Int)  {
      self.pixels = pixels
      self.width = width
      self.height = height
   }
}
