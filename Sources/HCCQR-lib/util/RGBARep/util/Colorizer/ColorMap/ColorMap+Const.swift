import Foundation
/**
 * colormaps
 */
extension Array where Element == ColorMapItem {
   /**
    * ColorMap (standard 4 color ColorMap)
    * - Fixme: ⚠️️ Since index is unique we can make this hashable 👌 (it will be faster probably), caseIteratable 👈 ,maybe difficult now that we have to support darkmode
    * - Fixme: ⚠️️ make two static let's one with darkmode and one with out, saves cpu etc
    * - Parameter useDarkMode: Enables the HCCQR to be inverted and support darkmode
    */
   public static func rgbColorMap(useDarkMode: Bool = false) -> ColorMap {
      [
         (idx: [false, true], Pixel.Colors.red), // red block 👉 (qr1: black, qr2: white)
         (idx: [true, false], Pixel.Colors.green), // green block 👉 (qr1: white, qr2: black)
         (idx: [true, true], Pixel.Colors.blue), // blue block 👉 (qr1: black, qr2: black)
         (idx: [false, false], useDarkMode ? Pixel.Colors.black : Pixel.Colors.white) // white block 👉 (qr1: white, qr2: white)
      ]
   }
}

// continue here:
   // store the bool array as a const.
   // store the rgb colors as an array, (same as color channels)
   // use zip or similar to weave in the data into the color map
