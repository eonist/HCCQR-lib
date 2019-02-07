import UIKit

extension RGBAImage{
   /**
    * TODO: ⚠️️ use throw instead of optional init?
    * TODO: ⚠️️ MOVE THE pixels conversion into a static method
    */
   static func rgbaImage(image:UIImage) -> RGBAImage? {
      guard let cgImage = image.cgImage else { Swift.print("unable to get cgImage");return nil  }
      let width = Int(image.size.width)
      let height = Int(image.size.height)
      let bytesPerRow = width * 4// 4 * width * height
      let imageData = UnsafeMutablePointer<Pixel>.allocate(capacity: width * height)
      let colorSpace = CGColorSpaceCreateDeviceRGB()
      var bitmapInfo: UInt32 = CGBitmapInfo.byteOrder32Big.rawValue//BGRA
      bitmapInfo = bitmapInfo | CGImageAlphaInfo.premultipliedLast.rawValue & CGBitmapInfo.alphaInfoMask.rawValue
      guard let imageContext = CGContext(data: imageData, width: width, height: height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo) else {
         return nil
      }
      imageContext.draw(cgImage, in: CGRect(origin: .zero, size: image.size))//cgImage.imageData
      let pixels = UnsafeMutableBufferPointer<Pixel>(start: imageData, count: width * height)
      return RGBAImage.init(pixels: pixels, width: width, height: height)
   }
   /**
    * Beta (trying to fix "blurry edge pixel bug")
    */
   static func rgbaImage(uiImage img:UIImage) -> RGBAImage? {
      guard let cgImage:CGImage = /*img.cgImage ?? */img.cgImage() else {Swift.print("unable to create cgImage");return nil}
      let pixelData = cgImage.dataProvider!.data
      let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
      let scale:CGFloat = img.scale
      let width:Int = Int(img.size.width*scale)
      let height:Int = Int(img.size.height*scale)
      let pixels:[Pixel] = (0..<height).flatMap{ y in
         (0..<width).map{ x in
            let pixelInfo: Int = ((Int(img.size.width*scale) * y) + x) * 4
            let pixel =  Pixel.init(r: data[pixelInfo], g: data[pixelInfo+1], b: data[pixelInfo+2], a: data[pixelInfo+3])
            return pixel
         }
      }
      
      let blackImg:UIImage = UIImage.createImage(size: CGSize.init(width: img.size.width*scale, height: img.size.height*scale), color: .black)
      let result : RGBAImage = RGBAImage.rgbaImage(image:blackImg)!
      var rgbaImage:RGBAImage = RGBAImage.init(pixels: result.pixels, width: Int(img.size.width*scale), height: Int(img.size.height*scale))
      let tempIMG:RGBAImage = RGBAImage.rgbaImage(pixels: pixels, width: Int(img.size.width*scale), height: Int(img.size.height*scale))
      rgbaImage.pixels = tempIMG.pixels
      rgbaImage.pixels.enumerated().forEach{
         rgbaImage.pixels[$0.offset] = $0.element
      }
      return rgbaImage
   }
   /**
    * Beta, might not work ⚠️️
    */
   static func rgbaImage(pixels:[Pixel], width:Int, height:Int) -> RGBAImage{
      //      let unsafePixels = UnsafeMutableBufferPointer<Pixel>.allocate(capacity: pixels.count)
      //      _ = unsafePixels.initialize(from: pixels)
      
      //      let count = pixels.count
      //      let ptr = UnsafeMutablePointer<Pixel>.allocate(capacity:count)
      //      let buffer = UnsafeMutableBufferPointer(start: ptr, count: count)
      //      for (i, _) in buffer.enumerated() {
      //         buffer[i] = pixels[i]
      //      }
      
      let blackImg:UIImage = UIImage.createImage(size: .init(width: width, height: height), color: .black)
      var result:RGBAImage = RGBAImage.rgbaImage(image:blackImg)!
      RGBAImage.fill(image: &result, pixels: pixels)
      return RGBAImage.init(pixels: result.pixels, width: width, height: height)
   }
}
