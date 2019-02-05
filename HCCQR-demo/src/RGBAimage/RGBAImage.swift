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
      self.pixels = UnsafeMutableBufferPointer<Pixel>(start: imageData, count: width * height)
   }
   /**
    * Beta (trying to fix "blurry edge pixel bug")
    */
   init?(img :UIImage){
      guard let cgImage:CGImage = img.cgImage() else {Swift.print("unable to create cgImage");return nil}
      let pixelData = cgImage.dataProvider!.data
      let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
      let scale:CGFloat = img.scale//2//
      let width:Int = Int(img.size.width*scale)
      Swift.print("width:  \(width)")
      Swift.print("img.scale:  \(img.scale)")
      let height:Int = Int(img.size.height*scale)
      Swift.print("height:  \(height)")
      var pixels:[Pixel] = []
      for y in 0..<height {
         for x in 0..<width {
            // img.getPixel(x:x,y:y)!
            let pixelInfo: Int = ((Int(img.size.width*scale) * y) + x) * 4
            let pixel =  Pixel.init(R: data[pixelInfo], G: data[pixelInfo+1], B: data[pixelInfo+2], A: data[pixelInfo+3])
            //            let pixel =  Pixel.init(R: 0, G: 0, B: 0, A: 255)
//            if (x == (80*2*2)-1 && y == 0) {
//               pixel.debug()
//            }
            pixels.append(pixel)
         }
      }
      
      Swift.print("pixels.count:  \(pixels.count)")
      let blackImg:UIImage = UIImage.createImage(size: CGSize.init(width: img.size.width*scale, height: img.size.height*scale), color: .black)
      let result : RGBAImage = RGBAImage(image:blackImg)!
      self.pixels = result.pixels
      self.width = Int(img.size.width*scale)
      self.height = Int(img.size.height*scale)
      let tempIMG:RGBAImage = .init(pixels: pixels, width: Int(img.size.width*scale), height: Int(img.size.height*scale))
      self.pixels = tempIMG.pixels
      pixels.enumerated().forEach{
         self.pixels[$0.offset] = $0.element
      }
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
