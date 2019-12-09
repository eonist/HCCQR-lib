import Foundation
/**
 * ColorMap
 */
extension Colorizer {
   /**
    * ColorMap (standard 4 color ColorMap)
    * - Fixme: ⚠️️ since index is unique we can make this hashable 👌 (it will be faster probably), caseIteratable 👈
    */
   internal static let colorMap: ColorMap = {
      [
         (idx: [0, 1], Color.red), // black, white
         (idx: [1, 0], Color.green), // white, black
         (idx: [1, 1], Color.blue), // black, black
         (idx: [0, 0], Color.white) // white, white
      ]
   }()
   /**
    * blandColorMap (washed out colors for testing)
    */
   internal static let blandColorMap: ColorMap = {
      [
         (idx: [0, 1], Color(red: 0.8, green: 0.2, blue: 0.2, alpha: 1)), // black, white
         (idx: [1, 0], Color(red: 0.2, green: 0.8, blue: 0.2, alpha: 1)), // white, black
         (idx: [1, 1], Color(red: 0.2, green: 0.2, blue: 0.8, alpha: 1)), // black, black
         (idx: [0, 0], Color(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)) // white, white
      ]
   }()
}
