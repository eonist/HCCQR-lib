import Foundation

extension ByteImage {
   /**
    * Get pix for x and y
    */
//   public mutating func pixel(x: Int, _ y: Int, _ pixel: BytePixel) {
//      guard x >= 0 && x < width && y >= 0 && y < height else { return }
//      let address = y * width + x
//      pixels[address] = pixel
//   }
   /**
    * Manipulate pixels
    */
   public mutating func process(output: inout UnsafeMutableBufferPointer<BytePixel>, functor: ((BytePixel) -> BytePixel) ) {
      for y in 0..<height {
         for x in 0..<width {
            let index = y * width + x
            let outPixel = functor(pixels[index])
            output[index] = outPixel
         }
      }
   }
   /**
    * Manipulate pixels with index
    */
   public func enumerate(functor: (Int, BytePixel) -> Void) {
      for y in 0..<height {
         for x in 0..<width {
            let index = y * width + x
            functor(index, pixels[index])
         }
      }
   }
}
