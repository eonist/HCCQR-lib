import Foundation
import ResultSugar
/**
 * channels
 */
extension Splitter {
   /**
    * For 4 color HCCQR,
    * - Fixme: ⚠️️ See .pdf's for the colors to use for 8-colorHCCQR etc
    */
   static let channelMap = [PixelData.red, PixelData.green, PixelData.blue]// { $0.isColorish() }, { $0.isColorish() }]
   /**
    * Split 3 RGBAImages into 3 singular r, g, b channels (white represents the channel color)
    * - Parameters:
    *   - rgbaImg: target to derive channels from
    *   - channelMap: ruleset for the splitting process
    *   - onComplete: notify when process has completed
    */
   static func channels(rgbaImg: RGBAImage, channelMap: [PixelData.RGBColor] = channelMap, onComplete:@escaping OnChannelsCompleted) {
      let assertions: [(PixelData) -> Bool] = channelMap.map { rgbColor in { $0.isColorish(rgbColor) } }
      var rgbaImages: [RGBAImage?] = [RGBAImage?](repeating: nil, count: assertions.count) // Fixme: ⚠️️ we could use unmanaged pointer with capacity as well, might be faster
      DispatchQueue.concurrentPerform(iterations: assertions.count) { i in // ⚠️️ Optimization initiative
         let item = (element: assertions[i], offset: i)
         let rgbaImage: RGBAImage = channel(rgbaImg: rgbaImg, assert: item.element) // Finds the red-channel, blue-channel, green-channel
         onChannelComplete(i: item.offset, rgbaImage: rgbaImage, rgbaImages: &rgbaImages, rgbaImg: rgbaImg, onComplete: onComplete)
      }
   }
}
/**
 * Private static helper methods
 */
extension Splitter {
   /**
    * Gets r,g,b channels
    * - Note: Marks red colors as black, all else becomes white
    * - Note: there is no speed benefit of writing the new pixeldata into a new rgba image, this was tested
    */
   private static func channel(rgbaImg: RGBAImage, assert: (_ pixel: PixelData) -> Bool) -> RGBAImage {
      // - Fixme: ⚠️️ I think we can create a blank RGBImage, as its faster than copy probably
//       let newImg =  RGBAImage.rgbaImage(pixel: PixelData.Colors.whitePixel, size: rgbaImg.size)//
      let newImg = RGBAImage.rgbaImage(capacity: rgbaImg.size.width * rgbaImg.size.height, size: rgbaImg.size)
      return rgbaImg.process(input: newImg) { pixel -> PixelData in
         assert(pixel) ? PixelData.Colors.whitePixel : PixelData.Colors.blackPixel
      }
   }
   /**
    * Channel completion handler
    * - Fixme: ⚠️️ simplify the deinit, refactor etc
    */
   private static func onChannelComplete(i: Int, rgbaImage: RGBAImage, rgbaImages: inout [RGBAImage?], rgbaImg: RGBAImage, onComplete: OnChannelsCompleted) {
      rgbaImages[i] = rgbaImage // it matters which order the qrImages came in when you stitch them back together
      if rgbaImages.first(where: { $0 == nil }) == nil { // makes sure all images finished (fastest way to check for nil)
         let rgbaImages: [RGBAImage] = rgbaImages.compactMap { $0 } // remove optionality
         onComplete(.success((rgbaImages[0], rgbaImages[1], rgbaImages[2])))
         rgbaImg.deinitiate() // to avoid memleak
      }
   }
}
//DispatchQueue.main.async { // I guess this is on main-thread because it writes into an array
//
//}
