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
//      var bitmapInfo: UInt32 = CGBitmapInfo.byteOrder32Big.rawValue
//      bitmapInfo |= CGImageAlphaInfo.premultipliedLast.rawValue & CGBitmapInfo.alphaInfoMask.rawValue
      let bitmapInfo: CGBitmapInfo = .init(rawValue: CGBitmapInfo.byteOrder32Big.rawValue | CGImageAlphaInfo.noneSkipLast.rawValue) // premultipliedLast also works
      let bytesPerPixel = MemoryLayout<BytePixel>.size
      let bytesPerRow = self.width * bytesPerPixel
//      Swift.print("MemoryLayout<BytePixel>.size:  \(MemoryLayout<BytePixel>.size)")
//      Swift.print("bytesPerRow:  \(bytesPerRow)")
      let bitsPerComponent: Int = 8 // (8 bits per each channel)
//      let bytesPerPixel: Int = 4 // 4 bytes(rgba channels) for each pixel
//      let bitsPerPixel: Int = bytesPerPixel * bitsPerComponent
      // work around ⚠️️⚠️️⚠️️ maybe do CFData etc
      guard let unsafePointer = self.pixels.baseAddress else { throw CGImageErr.unableToCreateCGImage }
      guard let imageContext = CGContext(data: .init(mutating: unsafePointer), width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo.rawValue, releaseCallback: nil, releaseInfo: nil) else { throw CGImageErr.unableToCreateCGImage }
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
//extension ByteImage {
//   /**
//    * Copy
//    */
//   internal func copy() -> ByteImage {
//      let capacity: Int = self.width * self.height
//      let resultPixels: UnsafeMutableBufferPointer<PixelData> = .allocate(capacity: capacity)
//      for y in 0..<height {
//         for x in 0..<width {
//            let index = y * width + x
//            resultPixels[index] = self.pixels[index]
//         }
//      }
//      return .init(pixels: pixels, width: width, height: height)
//   }
//}
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
