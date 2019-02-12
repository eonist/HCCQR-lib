import Foundation
/**
 * Asserter
 */
internal extension PixelData{
   internal static let redPixel:PixelData = .init(r:255,g:0,b:0,a:255)
   internal static let greenPixel:PixelData = .init(r:0,g:255,b:0,a:255)
   internal static let bluePixel:PixelData = .init(r:0,g:0,b:255,a:255)
   internal static var blackPixel:PixelData { return .init(r:0,g:0,b:0,a:255) }
   internal static var whitePixel:PixelData { return .init(r:255,g:255,b:255,a:255) }
   private static let threshold:CGFloat = 0.40
   private static let halfThreshold:CGFloat = threshold/2
//   static let thresholdUInt8:UInt8 =  UInt8(255*PixelData.threshold)
   internal static let halfThresholdUInt8:UInt8 =  UInt8(255*halfThreshold)
   /**
    * Asserts if a pixel is sort of red within a threshold
    */
   internal var isRedish:Bool {
      return self.isColor(pixel: PixelData.redPixel, halfThreshold: PixelData.halfThresholdUInt8)
   }
   /**
    * Asserts if a pixel is sort of green within a threshold
    */
   internal var isGreenish:Bool {
      return self.isColor(pixel: PixelData.greenPixel, halfThreshold: PixelData.halfThresholdUInt8)
   }
   /**
    * Asserts if a pixel is sort of blue within a threshold
    */
   internal var isBlueish:Bool {
      return self.isColor(pixel: PixelData.bluePixel, halfThreshold: PixelData.halfThresholdUInt8)
   }
   /**
    * Measure if color is white (used in the colorize method)
    */
   internal var isWhite:Bool {//was return self.r == 255 && self.g == 255 && self.b == 255
      return !(self.r != 255 || self.g != 255 || self.b != 255)//looks funky, but its fast
   }
   /**
    * Measure if color is black (used in the colorize method)
    */
   internal var isBlack:Bool {//was return self.r == 0 && self.g == 0 && self.b == 0
      return !(self.r != 0 || self.g != 0 || self.b != 0)//looks funky, but its fast
   }
}
/**
 * Assert
 */
internal extension PixelData {
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
   internal func isColor(pixel:PixelData, halfThreshold:UInt8) -> Bool{
      let rgb1:RGB = self.rgb
      let rgb2:RGB = pixel.rgb
      return isColor(rgb1:rgb1,rgb2:rgb2,halfThreshold:halfThreshold)
   }
   /**
    * Asserts if a color is near another color within a threshold
    */
   private func isColor(rgb1:RGB, rgb2:RGB, halfThreshold:UInt8, min:UInt8 = 0, max:UInt8 = 255) -> Bool{
      let r:Bool = {
         let range:RangeUInt8 = UInt8Parser.range(num: rgb2.r, halfThreshold: halfThreshold, min: min, max: max)//75,125
         return UInt8Asserter.within(num: rgb1.r, min: range.start, max: range.end)//(range.start...range.end).contains(rgb1.r)
      }()
      let g:Bool = {
         let range:RangeUInt8 = UInt8Parser.range(num: rgb2.g, halfThreshold: halfThreshold, min: min, max: max)
         return UInt8Asserter.within(num: rgb1.g, min: range.start, max: range.end)//(range.start...range.end).contains(rgb1.g)
      }()
      let b:Bool = {
         let range:RangeUInt8 = UInt8Parser.range(num: rgb2.b, halfThreshold: halfThreshold, min: min, max: max)
         return UInt8Asserter.within(num: rgb1.b, min: range.start, max: range.end)//(range.start...range.end).contains(rgb1.b)
      }()
      return r && g && b
   }
}
/**
 * Debugging
 */
internal extension PixelData{
   internal var isRed:Bool {
      Swift.print("dont use this in prod")
      return self.r == 255 && self.g == 0 && self.b == 0
   }
   internal var isBlue:Bool {
      Swift.print("dont use this in prod")
      return self.r == 0 && self.g == 0 && self.b == 255
   }
   internal var isGreen:Bool {
      Swift.print("dont use this in prod")
      return self.r == 0 && self.g == 255 && self.b == 0
   }
}
