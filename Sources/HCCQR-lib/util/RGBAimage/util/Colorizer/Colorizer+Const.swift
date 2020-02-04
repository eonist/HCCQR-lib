import Foundation
/**
 * ColorMap
 * - Abstract: Used in the creation process
 */
extension Colorizer {
   /**
    * ColorMap (standard 4 color ColorMap)
    * - Fixme: ⚠️️ since index is unique we can make this hashable 👌 (it will be faster probably), caseIteratable 👈
    * - Parameter useDarkMode: Enables th QR to be inverted and support darkmode
    */
   static func colorMap(useDarkMode: Bool = false) -> ColorMap {
      [
         (idx: [false, true], PixelData.red),   // red   block 👉 (qr1: black, qr2: white)
         (idx: [true, false], PixelData.green), // green block 👉 (qr1: white, qr2: black)
         (idx: [true, true], PixelData.blue),   // blue  block 👉 (qr1: black, qr2: black)
         (idx: [false, false], useDarkMode ? PixelData.black : PixelData.white) // white block 👉 (qr1: white, qr2: white)
      ]
   }
   /**
    * blandColorMap (washed out colors used for testing)
    */
//   internal static let blandColorMap: ColorMap = {
//      [
//         (idx: [false, true], PixelData.RGBColor(r: UInt8(0.8 * 255), g: UInt8(0.2 * 255), b: UInt8(0.2 * 255), a: 255)), // black, white
//         (idx: [true, false], Color(red: 0.2, green: 0.8, blue: 0.2, alpha: 1)), // white, black
//         (idx: [true, true], Color(red: 0.2, green: 0.2, blue: 0.8, alpha: 1)), // black, black
//         (idx: [false, false], Color(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)) // white, white
//      ]
//   }()
}
