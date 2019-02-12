import UIKit
/**
 * Class methods
 */
internal extension RGBAImage{
   /**
    * New (faster)
    */
   internal func getPixelUnChecked(x:Int, y:Int) -> PixelData {
      let address = y * width + x
      return pixels[address]
   }
   /**
    * Set pixel
    */
   internal mutating func setPixel(idx:Int,pixel:PixelData){
       pixels[idx] = pixel
   }
   internal typealias FunctorCall = ((PixelData) -> PixelData)
   /**
    * Applies pixels with a method
    */
   internal mutating func process(functor:FunctorCall) {
      (0..<self.height).forEach{ y in
         (0..<self.width).forEach { x in
            let index:Int = y * width + x
            let outPixel:PixelData = functor(pixels[index])
            pixels[index] = outPixel
         }
      }
   }
   internal typealias FunctorIndexCall = ((Int,PixelData) -> PixelData)
   internal mutating func process(functor:FunctorIndexCall) {
      (0..<self.height).forEach{ y in
         (0..<self.width).forEach { x in
            let index:Int = y * width + x
            let outPixel:PixelData = functor(index,pixels[index])
            pixels[index] = outPixel
         }
      }
   }
   /**
    * New
    */
//   public func process(unsafePixels: UnsafeMutableBufferPointer<PixelData>, functor:FunctorCall)  {
//      (0..<self.height).forEach{ y in
//         return (0..<self.width).forEach{ x in
//            let index:Int = y * width + x
//            let outPixel:PixelData = functor(pixels[index])
//            unsafePixels[index] = outPixel
//         }
//      }
//   }
   var copy:RGBAImage{
      return RGBAImage.rgbaImage(pixels: pixels.map{$0}, size: (width,height))
   }
}

/**
 * DEPRECATED
 */
extension RGBAImage{
   /**
    * New, unused
    */
   private var getPixels:[PixelData] {
      Swift.print("dont use this")
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
   private func getPixel(x:Int, y:Int) -> PixelData? {
      Swift.print("dont use this")
      guard x >= 0 && x < width && y >= 0 && y < height else {Swift.print("setPixel() - out of bound"); return nil }
      let address = y * width + x
      return pixels[address]
   }
   /**
    * Set pixel
    * - IMPORTANT: ⚠️️ Not in use ⚠️️
    */
   private mutating func setPixel(x:Int,  y:Int,  pixel:PixelData) {
      Swift.print("dont use this")
      guard x >= 0 && x < width && y >= 0 && y < height else {Swift.print("setPixel() - out of bound"); return }
      let address = y * width + x
      pixels[address] = pixel
   }
}
