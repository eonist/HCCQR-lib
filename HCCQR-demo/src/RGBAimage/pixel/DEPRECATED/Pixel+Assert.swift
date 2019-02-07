import UIKit
/**
 * Assert
 */
extension Pixel{
   static let redPixel:Pixel = .init(r:255,g:0,b:0,a:255)
   static let greenPixel:Pixel = .init(r:0,g:255,b:0,a:255)
   static let bluePixel:Pixel = .init(r:0,g:0,b:255,a:255)
   static let threshold:CGFloat = 0.35
   static let thresholdUInt8:UInt8 =  UInt8(255*Pixel.threshold)
   /**
    * Asserts if a pixel is sort of red within a threshold
    */
   var isRedish:Bool {
      return self.isColor(pixel: Pixel.redPixel, threshold: Pixel.thresholdUInt8)
   }
   /**
    * Asserts if a pixel is sort of green within a threshold
    */
   var isGreenish:Bool {
      return self.isColor(pixel: Pixel.greenPixel, threshold: Pixel.thresholdUInt8)
   }
   /**
    * Asserts if a pixel is sort of blue within a threshold
    */
   var isBlueish:Bool {
      return self.isColor(pixel: Pixel.bluePixel, threshold: Pixel.thresholdUInt8)
   }
}
/**
 * Assert
 */
extension Pixel {
   /**
    * Assert color within threshold
    * ## Examples:
    * let offset:UInt8 = UInt8(255*0.2)
    * let redishPixel:Pixel = .init(R:255-offset,G:0+offset,B:0+offset,A:255)
    * let redPixel:Pixel = .init(R:255,G:0,B:0,A:255)
    * let threshold:UInt8 = UInt8(255*0.25)
    * let isColorRedish:Bool = redishPixel.isColor(pixel:redPixel,threshold:threshold)
    * Swift.print("isColorRedish:  \(isColorRedish)")//true
    */
   func isColor(pixel:Pixel, threshold:UInt8) -> Bool{
      let rgb1:RGB = self.rgb
      let rgb2:RGB = pixel.rgb
      return isColor(rgb1:rgb1,rgb2:rgb2,threshold:threshold)
   }
   /**
    * Asserts if a color is within another color within a threshold
    */
   private func isColor(rgb1:RGB,rgb2:RGB, threshold:UInt8, min:UInt8 = 0, max:UInt8 = 255) -> Bool{
      let r:Bool = {
         let range = UInt8Parser.range(number: rgb2.r, min: min, max: max, threshold: threshold)
         return (range.start...range.end).contains(rgb1.r)
      }()
      let g:Bool = {
         let range = UInt8Parser.range(number: rgb2.g, min: min, max: max, threshold: threshold)
         return (range.start...range.end).contains(rgb1.g)
      }()
      let b:Bool = {
         let range = UInt8Parser.range(number: rgb2.b, min: min, max: max, threshold: threshold)
         return (range.start...range.end).contains(rgb1.b)
      }()
      return r && g && b
   }
}
