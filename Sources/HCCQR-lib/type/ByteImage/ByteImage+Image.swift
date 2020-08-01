import CoreImage

extension ByteImage {
   /**
    * Image
    */
   internal func image(scale: CGFloat) throws -> Image {
      let cgImg = try cgImage()
      let image = ImageUtil.image(cgImage: cgImg, scale: scale)
      return image
   }
   /**
    * CGImage
    */
   internal func cgImage() throws -> CGImage {
      let colorSpace = CGColorSpaceCreateDeviceRGB()
      var bitmapInfo: UInt32 = CGBitmapInfo.byteOrder32Big.rawValue
      let bytesPerRow = width * 4
      bitmapInfo |= CGImageAlphaInfo.premultipliedLast.rawValue & CGBitmapInfo.alphaInfoMask.rawValue
      // work around ⚠️️⚠️️⚠️️ maybe do CFData etc
      let mutablePointer: UnsafeMutableBufferPointer<PixelData> = .init(mutating: self.pixels)
      guard let imageContext = CGContext(data: mutablePointer.baseAddress, width: width, height: height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo, releaseCallback: nil, releaseInfo: nil) else { throw CGImageErr.unableToCreateCGImage }
      guard let cgImage = imageContext.makeImage() else { throw CGImageErr.unableToCreateCGImage }
      return cgImage
   }
   /**
    * CIImage
    */
   internal func ciImage(useGrayscale: Bool) throws -> CIImage {
      fatalError("not supported yet")
   }
}
/**
 * Extra
 */
extension ByteImage {
   /**
    * Copy
    */
   internal func copy() -> ByteImage {
      let capacity: Int = self.width * self.height
      let resultPixels: UnsafeMutableBufferPointer<PixelData> = .allocate(capacity: capacity)
      for y in 0..<height {
         for x in 0..<width {
            let index = y * width + x
            resultPixels[index] = self.pixels[index]
         }
      }
      return .init(pixels: pixels, width: width, height: height)
   }
}
/**
 * Make functors into typealiases
 */
//extension ByteImage {
//   /**
//    * Manipulate pixels
//    */
//   internal mutating func process(output: inout UnsafeMutableBufferPointer<PixelData>, functor: ((PixelData) -> PixelData) ) {
//      for y in 0..<height {
//         for x in 0..<width {
//            let index = y * width + x
//            let outPixel = functor(pixels[index])
//            output[index] = outPixel
//         }
//      }
//   }
//   /**
//    * Manipulate pixels with index
//    */
//   internal func enumerate(functor: (Int, PixelData) -> Void) {
//      for y in 0..<height {
//         for x in 0..<width {
//            let index = y * width + x
//            functor(index, pixels[index])
//         }
//      }
//   }
//}
/**
 * Get pix for x and y
 */
//   public mutating func pixel(x: Int, _ y: Int, _ pixel: BytePixel) {
//      guard x >= 0 && x < width && y >= 0 && y < height else { return }
//      let address = y * width + x
//      pixels[address] = pixel
//   }
