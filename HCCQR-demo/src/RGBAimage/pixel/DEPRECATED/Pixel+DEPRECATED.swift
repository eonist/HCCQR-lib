//
//  Pixel+DEPRECATED.swift
//  HCCQR-demo
//
//  Created by Eon on 07/02/2019.
//  Copyright © 2019 FutureLab. All rights reserved.
//

import UIKit

/**
 * Assert (DEPRECATED)
 * ⚠️️ Not in use anymore ⚠️️
 */
public extension Pixel{
   /**
    * Measure if color is red
    * - Description: basically measure if there is more r than g or b
    */
   var isRed:Bool {
      return self.r == 255 && self.g != 255 && self.b != 255
   }
   /**
    * Measure if color is green
    */
   var isGreen:Bool {
      return self.r != 255 && self.g == 255 && self.b != 255
   }
   /**
    * Measure if color is blue
    */
   var isBlue:Bool {
      return self.r != 255 && self.g != 255 && self.b == 255
   }
   /**
    * Measure if color is white
    */
   var isWhite:Bool {
      return self.r == 255 && self.g == 255 && self.b == 255
   }
   /**
    * Measure if color is black
    */
   var isBlack:Bool {
      return self.r == 0 && self.g == 0 && self.b == 0
   }
}
