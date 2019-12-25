import Foundation
import ResultSugar
/**
 * Utils
 * - Fixme: ⚠️️ Maybe rename to RGBAImageSplitter
 */
extension Splitter {
   /**
    * Returns channels (rgb for now) (3 channels, red, green, blue)
    */
   static func channels(image: Image, onComplete:@escaping OnChannelsCompleted) {
      guard let rgbaImg: RGBAImage = try? .rgbaImage(image: image) else { onComplete(.failure(NSError("Unable to create rgbaImg"))); return }
      channels(rgbaImg: rgbaImg, onComplete: onComplete)
   }
}
/**
 * Private static helpers
 */
extension Splitter {
   /**
    * Split 3 RGBAImages into 3 singular rgb channels (white represents the channel color)
    * - Fixme: ⚠️️ add rethrow here I guess, or result?
    */
   /*private */static func channels(rgbaImg: RGBAImage, onComplete:@escaping OnChannelsCompleted) {
      // - Fixme: ⚠️️ can we move the bellow asserion in to a priv static method or var?
      let assertions: [(PixelData) -> Bool] = [ { $0.isRedish }, { $0.isGreenish }, { $0.isBlueish }]
      var rgbaImages: [RGBAImage?] = [RGBAImage?](repeating: nil, count: assertions.count)
      assertions.enumerated().forEach { item in
         DispatchQueue.global(qos: .userInitiated).async { // - Fixme ⚠️️ use the sync method instead here, assert improvment?
            let rgbaImage: RGBAImage = channel(rgbaImg: rgbaImg, assert: item.element)
            DispatchQueue.main.async { // I guess this is on main-thread because it writes into an array
               onChannelComplete(i: item.offset, rgbaImage: rgbaImage, rgbaImages: &rgbaImages, rgbaImg: rgbaImg, onComplete: onComplete)
            }
         }
      }
   }
   /**
    * Channel completion handler
    * - Fixme: ⚠️️ simplify the deinit, refactor etc
    */
   private static func onChannelComplete(i: Int, rgbaImage: RGBAImage, rgbaImages: inout [RGBAImage?], rgbaImg: RGBAImage, onComplete: OnChannelsCompleted) {
      rgbaImages[i] = rgbaImage // it matters which order the qrImages came in when you stitch them back together
      if rgbaImages.first(where: { $0 == nil }) == nil { // makes sure all images finished
         let rgbaImages: [RGBAImage] = rgbaImages.compactMap { $0 }
         onComplete(.success((rgbaImages[0], rgbaImages[1], rgbaImages[2])))
         rgbaImg.deinitiate()/*to avoid memleak*/
      }
   }
   /**
    * Gets rgb channels
    * - Note: Marks red colors as black, all else becomes white
    * - Note: there is no speed benefit of writing the new pixeldata into a new rgba image, this was tested
    */
   private static func channel(rgbaImg: RGBAImage, assert: (_ pixel: PixelData) -> Bool) -> RGBAImage {
      var outImage = rgbaImg.copy
      outImage.process { pixel -> PixelData in
         assert(pixel) ? PixelData.Colors.whitePixel : PixelData.Colors.blackPixel
      }
      return outImage
   }
}
