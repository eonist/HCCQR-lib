import UIKit

public struct RGBAImage {
    public var pixels: UnsafeMutableBufferPointer<Pixel>
    public var width: Int
    public var height: Int
   /**
    * TODO: ⚠️️ use throw instead of optional init?
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
    * 
    */
   public init(pixels:UnsafeMutableBufferPointer<Pixel>,width:Int,height:Int)  {
      self.pixels = pixels
      self.width = width
      self.height = height
   }
}


