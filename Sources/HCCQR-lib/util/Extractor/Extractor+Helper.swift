import QuartzCore

extension Extractor {
   /**
    * The purpouse of this method is to setup static calls, that compare channel and pixel color
    * - Important: ⚠️️ For some reason this method has to be on the same line or else the linter complains
    * - Fixme: ⚠️️ Avoid regenerating these everytime, store as static let? TBH I don't think anything expensive is regenerated, just normal calls etc, maybe keep as is
    */
   static func similarities(pallete: ChannelPallete) -> [PixelSimilarity] {
      let halfThreshold: UInt8 = Pixel.getHalfThreshold(1.0 / CGFloat(pallete.count)) // we must use finer threshold if we use more colors (2.5 for 4-color, 0.125 for 8-color)
      return pallete.map { (channel: Pixel) in { (ishColor: Pixel) in channel.isSimilar(ishColor, halfThreshold: halfThreshold) } }
   }
}
