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
