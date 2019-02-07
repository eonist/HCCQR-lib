import UIKit
/**
 * Setter
 */
public extension Pixel{
   /**
    * setPixel (0-255) (⚠️️ not optimized ⚠️️)
    */
   mutating func setRGBA(r:UInt8,g:UInt8,b:UInt8,a:UInt8 = 255){
      self.r = r
      self.g = g
      self.b = b
      self.a = a
   }
   /**
    * setRGBA (⚠️️ not optimized ⚠️️)
    */
   mutating func setRGBA(color:UIColor) {
      guard let rgba = PixelUtil.rgba(uiColor:color) else {Swift.print("Unable to get rgba");return}//.rgba
      setRGBA(r: rgba.r, g: rgba.g, b: rgba.b, a: rgba.a)
     
      
//      
//
//      var int = UInt32()
//      //Scanner(string: hex).scanHexInt32(&int)
//      let a, r, g, b: UInt32
//      switch hex.count {
//      case 3: // RGB (12-bit)
//         (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
//      case 6: // RGB (24-bit)
//         (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
//      case 8: // ARGB (32-bit)
//         (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
//      default:
//         (a, r, g, b) = (255, 0, 0, 0)
//      }

      
      
      
      
      
      
      //      Swift.print("color.rgbValue:  \(color.rgbValue)")
      //      Swift.print("rgba:  \(rgba)")
      //      color.rgbValues
      
//      guard let rgbaHexValue = color.rgbValue else {Swift.print("unable to setRGBA");return}
//      Swift.print("rgbaHexValue:  \(rgbaHexValue)")
//      self.value = UInt32(rgbaHexValue)
//      Swift.print("self.value:  \(self.value)")
//      Swift.print("self.value:  \(self.value)")
//      Swift.print("r:  \(r)")
//      Swift.print("g:  \(g)")
//      Swift.print("b:  \(b)")
//
//      let R = self.value >> 16 & 0xFF
//      let G = self.value >> 8 & 0xFF
//      let B = self.value & 0xFF
//
//      Swift.print("R:  \(R)")
//      Swift.print("G:  \(G)")
//      Swift.print("B:  \(B)")
//      let rgb = color.rgbValues!
//      let temp:Int = (rgb.alpha << 24) + (rgb.red << 16) + (rgb.green << 8) + rgb.blue
//      Swift.print("temp:  \(temp )")//
   }
   /**
    * Makes pixel black
    */
   mutating func setBlack(){
      self.value = 4278190080
//      self.setRGBA(r: 0, g: 0, b: 0)
   }
   /**
    * Makes pixel white
    */
   mutating func setWhite(){
      self.value = 4294967295
//      self.setRGBA(r: 255, g: 255, b: 255)
   }
}

