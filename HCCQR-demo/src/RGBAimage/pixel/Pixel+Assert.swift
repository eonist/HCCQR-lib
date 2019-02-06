import UIKit
/**
 * Assert
 */
public extension Pixel{
   /**
    * Measure if color is red
    * - Description: basically measure if there is more r than g or b
    */
   var isRed:Bool {
      return self.R == 255 && self.G != 255 && self.B != 255
   }
   /**
    * Measure if color is green
    */
   var isGreen:Bool {
      return self.R != 255 && self.G == 255 && self.B != 255
   }
   /**
    * Measure if color is blue
    */
   var isBlue:Bool {
      return self.R != 255 && self.G != 255 && self.B == 255
   }
   /**
    * Measure if color is white
    */
   var isWhite:Bool {
      return self.R == 255 && self.G == 255 && self.B == 255
   }
   /**
    * Measure if color is black
    */
   var isBlack:Bool {
      return self.R == 0 && self.G == 0 && self.B == 0
   }
}
/**
 * Assert
 */
extension Pixel {
   /**
    * Assert color within threshold
    * ## Examples:
    * let redishPixel:Pixel = Pixel(r:UIInt8(255*0.80),g:UIInt8(0*0.20),b:UIInt8(0*0.20))
    * isColor(pixel:Pixel(r:255,g:0,b:0),threshold:UIInt8(255*0.25))
    */
   func isColor(pixel:Pixel, threshold:UInt8) -> Bool{
      let rgb1:RGB = self.rgb
      let rgb2:RGB = pixel.rgb
      return isColor(rgb1:rgb1,rgb2:rgb2,threshold:threshold)
   }
   typealias RGB = (r:UInt8,b:UInt8,g:UInt8)
   /**
    * Helper
    */
   private func isColor(rgb1:RGB,rgb2:RGB, threshold:UInt8, min:UInt8 = 0, max:UInt8 = 255) -> Bool{
      let r:Bool = {
         let range = UInt8Parser.range(number: rgb2.r, min: min, max: max, threshold: threshold)
//         Swift.print("range:  \(range)")
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
//      Swift.print("r:  \(r)")
//      Swift.print("g:  \(g)")
//      Swift.print("b:  \(b)")
      return r && g && b
   }
}
