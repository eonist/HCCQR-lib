import Foundation

extension Channel {
   /**
    * ⚠️️⚠️️⚠️️DEPRECATE SOON⚠️️⚠️️⚠️️
    * These are the assertions for splitting RGBAImage to grayscale channels
    */
   static let assertions: [PixelDataAssertion] = channelMap.map { rgbColor in { $0.isColorish(rgbColor) } }
   /**
    * - Note: This is the new way to do it
    */
   static let similarities: [PixelDataSimilarity] = channelMap.map { rgbColor in { $0.isSimilar(rgbColor) } }
}
