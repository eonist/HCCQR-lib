import Foundation
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
//      Swift.print("RGBAImage Created")
      self.pixels = pixels
      self.width = width
      self.height = height
      RGBAImage.initiatedCount += 1
   }
}
/**
 * Convenience
 */
extension RGBAImage{
   var size:(width:Int,height:Int) {return (width:width,height:height)}
}
extension RGBAImage{
   public static var initiatedCount:Int = 0
   public static var deInitiatedCount:Int = 0
   func deinitiate(){
      pixels.deallocate()
      RGBAImage.deInitiatedCount += 1
   }
}
