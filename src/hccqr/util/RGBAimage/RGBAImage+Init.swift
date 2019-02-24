import Foundation

internal extension RGBAImage{
   /**
    * TODO: ⚠️️ use throw instead of optional init?
    * - Note: this init is fast. trying other ways to get pixel could have some usefulness, but shouldnt be prioritized
    */
   internal static func rgbaImage(image:Image) -> RGBAImage? {
      //⚠️️ the bellow temp fix could hurt performance
      #if os(iOS)
      guard let cgImage = image.cgImage ?? image.cgImage() else { Swift.print("rgbaImage - Unable to get cgImage");return nil  }
      #elseif os(macOS)
      guard let cgImage = /* image.cgImage ??*/ image.cgImage() else { Swift.print("rgbaImage - Unable to get cgImage");return nil  }
      #endif
      let w = Int(image.size.width)
      let h = Int(image.size.height)
      let bytesPerRow = w * 4// 4 * width * height
      let capacity:Int = w * h
      let imageData = UnsafeMutablePointer<PixelData>.allocate(capacity: capacity)
      let colorSpace = CGColorSpaceCreateDeviceRGB()
      var bitmapInfo: UInt32 = CGBitmapInfo.byteOrder32Big.rawValue//BGRA
      bitmapInfo = bitmapInfo | CGImageAlphaInfo.premultipliedLast.rawValue & CGBitmapInfo.alphaInfoMask.rawValue
      guard let imageContext = CGContext(data: imageData, width: w, height: h, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo) else {
         Swift.print("unable to create rgbaImage")
         return nil
      }
      imageContext.draw(cgImage, in: CGRect(origin: .zero, size: image.size))//cgImage.imageData
      let pixels = UnsafeMutableBufferPointer<PixelData>(start: imageData, count: capacity)
      let rgbaImg:RGBAImage = .init(pixels: pixels, width: w, height: h)
      return rgbaImg
   }
   /**
    * Beta (scales img without becoming blurry)
    */
   internal static func rgbaImage(pixels:[PixelData], size:(width:Int,height:Int), moduleMultiplier:Int) -> RGBAImage{
      let resultPixels:[PixelData] = (0..<size.height * moduleMultiplier).flatMap{ y in
         return (0..<size.width*moduleMultiplier).map{ x in
            let pixelIndex:Int = y/moduleMultiplier*size.height+x/moduleMultiplier
            return pixels[pixelIndex]
         }
      }
      return rgbaImage(pixels: resultPixels, size:(width: size.width*moduleMultiplier, height: size.height*moduleMultiplier))
   }
   /**
    * Beta
    */
   internal static func rgbaImage(pixels:[PixelData], size:(width:Int,height:Int)) -> RGBAImage{
      let unsafePixels = UnsafeMutableBufferPointer<PixelData>.allocate(capacity:pixels.count)
      _ = unsafePixels.initialize(from: pixels)
      return RGBAImage.init(pixels: unsafePixels, width: size.width, height: size.height)
   }
   /**
    * New
    */
   internal static func rgbaImage(pixel:PixelData, size:(width:Int,height:Int)) -> RGBAImage{
      let capacity:Int = size.width * size.height
      let unsafePixels = UnsafeMutableBufferPointer<PixelData>.allocate(capacity:capacity)
      (0..<size.height).forEach{ y in
         return (0..<size.width).forEach{ x in
            let pixelIndex:Int = y*size.width+x
            unsafePixels[pixelIndex] = pixel
         }
      }
      return RGBAImage.init(pixels: unsafePixels, width: size.width, height: size.height)
   }
}
