import UIKit
/**
 * Class methods
 */
extension RGBAImage{
   /**
    * New, unused
    */
   var getPixels:[PixelData] {
      return (0..<height).flatMap{ y in
         (0..<width).compactMap{ x in
            return getPixel(x: x, y: y)
         }
      }
   }
   /**
    * Get pixel
    * - IMPORTANT: ⚠️️ Not in use ⚠️️
    */
   public func getPixel(x:Int, y:Int) -> PixelData? {
      guard x >= 0 && x < width && y >= 0 && y < height else {Swift.print("setPixel() - out of bound"); return nil }
      let address = y * width + x
      return pixels[address]
   }
   /**
    * Set pixel
    * - IMPORTANT: ⚠️️ Not in use ⚠️️
    */
   public mutating func setPixel(x:Int,  y:Int,  pixel:PixelData) {
      guard x >= 0 && x < width && y >= 0 && y < height else {Swift.print("setPixel() - out of bound"); return }
      let address = y * width + x
      pixels[address] = pixel
   }
   /**
    * Set pixel
    */
   public mutating func setPixel(idx:Int,pixel:PixelData){
       pixels[idx] = pixel
   }
   public typealias FunctorCall = ((PixelData) -> PixelData)
   /**
    * Applies pixels with a method
    */
   public mutating func process(functor:FunctorCall) {
      (0..<self.height).forEach{ y in
         (0..<self.width).forEach { x in
            let index:Int = y * width + x
            let outPixel = functor(pixels[index])
            pixels[index] = outPixel
         }
      }
   }
   var copy:RGBAImage{
      return RGBAImage.rgbaImage(pixels: pixels.map{$0}, size: (width,height))
   }
}
