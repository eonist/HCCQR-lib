import UIKit
/**
 * TODO: ⚠️️ You have to dealocate the memory at some point, see: https://stackoverflow.com/questions/34750166/how-to-use-unsafemutablebufferpointer
 */
public struct RGBAImage {
    public var pixels: UnsafeMutableBufferPointer<Pixel>
    public var width: Int
    public var height: Int
   /**
    * TODO: ⚠️️ use throw instead of optional init?
    * TODO: ⚠️️ MOVE THE pixels conversion into a static method
    */
   public init?(image: UIImage) {
      guard let cgImage = image.cgImage else {// get cgImage from uiImage
         return nil
      }
      width = Int(image.size.width)
      height = Int(image.size.height)
      let bytesPerRow = width * 4// 4 * width * height
      let imageData = UnsafeMutablePointer<Pixel>.allocate(capacity: width * height)
      let colorSpace = CGColorSpaceCreateDeviceRGB()
      var bitmapInfo: UInt32 = CGBitmapInfo.byteOrder32Big.rawValue//BGRA
      bitmapInfo = bitmapInfo | CGImageAlphaInfo.premultipliedLast.rawValue & CGBitmapInfo.alphaInfoMask.rawValue
      guard let imageContext = CGContext(data: imageData, width: width, height: height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo) else {
         return nil
      }
      imageContext.draw(cgImage, in: CGRect(origin: .zero, size: image.size))//cgImage.imageData
      pixels = UnsafeMutableBufferPointer<Pixel>(start: imageData, count: width * height)
   }
   /**
    * Creates a copy if you already have the pixels and width height
    * - IMPORTANT: ⚠️️ Not in use ⚠️️
    */
   public init(pixels:UnsafeMutableBufferPointer<Pixel>, width:Int, height:Int)  {
      self.pixels = pixels
      self.width = width
      self.height = height
   }
   /**
    * Beta, might not work ⚠️️
    */
   public init(pixels:[Pixel], width:Int, height:Int){
//      let unsafePixels = UnsafeMutableBufferPointer<Pixel>.allocate(capacity: pixels.count)
//      _ = unsafePixels.initialize(from: pixels)
      
//      let count = pixels.count
//      let ptr = UnsafeMutablePointer<Pixel>.allocate(capacity:count)
//      let buffer = UnsafeMutableBufferPointer(start: ptr, count: count)
//      for (i, _) in buffer.enumerated() {
//         buffer[i] = pixels[i]
//      }
      
      let blackImg:UIImage = UIImage.createImage(size: .init(width: width, height: height), color: .black)
      var result : RGBAImage = RGBAImage(image:blackImg)!

      RGBAImage.fill(image: &result, pixels: pixels)
      
      self.init(pixels: result.pixels, width: width, height: height)
   }
}
