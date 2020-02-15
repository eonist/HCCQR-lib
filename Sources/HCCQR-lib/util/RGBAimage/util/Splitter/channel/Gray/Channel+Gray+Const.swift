import Foundation

extension Channel {
   /**
    * These are the assertions for splitting RGBAImage to grayscale channels
    */
   static let assertions: [PixelDataAssertion] = channelMap.map { rgbColor in { $0.isColorish(rgbColor) } }
}
