import CoreImage

extension ByteImage {
   /**
    * getPixel
    */
   public func pixel(x: Int, _ y: Int) -> BytePixel? {
      guard x >= 0 && x < width && y >= 0 && y < height else {
         return nil
      }
      let address = y * width + x
      return pixels[address]
   }
   /**
    * Clone
    * - Fixme: ⚠️️ rename to copy
    */
   public func clone() -> ByteImage {
      let cloneImage = ByteImage(pixels: pixels, width: self.width, height: self.height)
      for y in 0..<height {
         for x in 0..<width {
            let index = y * width + x
            cloneImage.pixels[index] = self.pixels[index]
         }
      }
      return cloneImage
   }
   /**
    * Image
    * - Fixme: ⚠️️ rename to image
    */
   public func toUIImage() -> Image? {
      let colorSpace = CGColorSpaceCreateDeviceRGB()
      var bitmapInfo: UInt32 = CGBitmapInfo.byteOrder32Big.rawValue
      let bytesPerRow = width * 4
      bitmapInfo |= CGImageAlphaInfo.premultipliedLast.rawValue & CGBitmapInfo.alphaInfoMask.rawValue
      guard let imageContext = CGContext(data: pixels.baseAddress, width: width, height: height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo, releaseCallback: nil, releaseInfo: nil) else {
         return nil
      }
      guard let cgImage = imageContext.makeImage() else {
         return nil
      }
      let image = ImageUtil.image(cgImage: cgImage)
      return image
   }
}
