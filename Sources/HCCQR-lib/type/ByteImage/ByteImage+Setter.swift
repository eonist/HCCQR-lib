import Foundation

extension ByteImage {
   public mutating func pixel(x: Int, _ y: Int, _ pixel: BytePixel) {
      guard x >= 0 && x < width && y >= 0 && y < height else {
         return
      }
      let address = y * width + x
      pixels[address] = pixel
   }
   public mutating func process(functor: ((BytePixel) -> BytePixel) ) {
      for y in 0..<height {
         for x in 0..<width {
            let index = y * width + x
            let outPixel = functor(pixels[index])
            pixels[index] = outPixel
         }
      }
   }
   public func enumerate(functor: (Int, BytePixel) -> Void) {
      for y in 0..<height {
         for x in 0..<width {
            let index = y * width + x
            functor(index, pixels[index])
         }
      }
   }
}
