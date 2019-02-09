import UIKit
/**
 * TODO: ⚠️️ You have to dealocate the memory at some point, see: https://stackoverflow.com/questions/34750166/how-to-use-unsafemutablebufferpointer
 */
public struct RGBAImage {
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
//   func getPixels() -> [PixelData] {
//      return (0..<height).flatMap{ y in
//         (0..<width).map{ x in
//            return getPixel(x: x, y: y)!
//         }
//      }
//   }
}
