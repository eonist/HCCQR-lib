import Foundation
/**
 * ColorMap
 * - Abstract: Used in the creation process
 */
extension Colorizer {
   /**
    * ColorMap (standard 4 color ColorMap)
    * - Fixme: ⚠️️ Since index is unique we can make this hashable 👌 (it will be faster probably), caseIteratable 👈 ,maybe difficult now that we have to support darkmode
    * - Parameter useDarkMode: Enables the HCCQR to be inverted and support darkmode
    */
   static func colorMap(useDarkMode: Bool = false) -> ColorMap {
      [
         (idx: [false, true], PixelData.red),   // red   block 👉 (qr1: black, qr2: white)
         (idx: [true, false], PixelData.green), // green block 👉 (qr1: white, qr2: black)
         (idx: [true, true], PixelData.blue),   // blue  block 👉 (qr1: black, qr2: black)
         (idx: [false, false], useDarkMode ? PixelData.black : PixelData.white) // white block 👉 (qr1: white, qr2: white)
      ]
   }
}
