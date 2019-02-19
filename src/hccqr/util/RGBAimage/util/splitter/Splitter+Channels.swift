import Foundation
/**
 * Utils
 * - TODO: ⚠️️ Rename to RGBAImageSplitter
 */
internal extension Splitter {
   /**
    * Returns channels (rgb for now)
    */
   internal static func channels(image:Image,onComplete:@escaping OnOptionalChannelsComplete)/* -> RGBAImages?*/{
      //      let startTime:Date = Date()
      guard let rgbaImg:RGBAImage = RGBAImage.rgbaImage(image: image) else {Swift.print("Splitter.channels() - Unable to create rgbaImg");onComplete(nil);return}
      //      Swift.print("Time to create rgbaImage: \(abs(startTime.timeIntervalSinceNow))")
      channels(rgbaImg:rgbaImg,onComplete:onComplete)//{onComplete($0)}
   }
   internal typealias OnChannelsComplete = (_ rgbaImages:RGBAImages) -> Void
   /**
    * Split 3 RGBAImages into 3 singular rgb channels (white represents the channel color)
    */
   internal static func channels(rgbaImg:RGBAImage, onComplete:@escaping OnChannelsComplete)/* -> RGBAImages*/ {
      let assertions:[(PixelData)->Bool] = [{$0.isRedish},{$0.isGreenish},{$0.isBlueish}]
      var rgbaImages:[RGBAImage?] = [RGBAImage?](repeating: nil, count: assertions.count)
      func onChannelComplete(i:Int, rgbaImage:RGBAImage){
         rgbaImages[i] = rgbaImage//it matters which order the qrImages came in when you stitch them back together
         if rgbaImages.first(where: {$0 == nil}) == nil {/*makes sure all images finished*/
            let rgbaImages:[RGBAImage] = rgbaImages.compactMap{$0}
            //Swift.print("Time to get rgb channels: \(abs(startTime.timeIntervalSinceNow))")
            onComplete((rgbaImages[0],rgbaImages[1],rgbaImages[2]))
            Swift.print("Splitter.channels - Deallocate")
            rgbaImg.pixels.deallocate()
//            rgbaImages.forEach{$0.pixels.deallocate()}
         }
      }
      assertions.enumerated().forEach{ item in
         DispatchQueue.global(qos:.userInitiated).async {
            let rgbaImage:RGBAImage = channel(rgbaImg:rgbaImg,assert:item.element)
            //            let qrImg:UIImage? = QRUtil.qrImage(str: arg.element, size: .init(width:length,height:length), ecLevel: ecLevel)
            DispatchQueue.main.async{
               onChannelComplete(i:item.offset,rgbaImage: rgbaImage)
            }
         }
      }
   }
}
/**
 * Helper
 */
fileprivate extension Splitter {
   /**
    * Gets rgb channels
    * - Note: Marks red colors as black, all else becomes white
    * - Note: there is no speed benefit of wtrting the new pixeldata into a new rgba image, this was tested
    */
   fileprivate static func channel(rgbaImg:RGBAImage, assert:(_ pixel:PixelData) -> Bool) -> RGBAImage{
      var outImage = rgbaImg.copy
      outImage.process{ (pixel) -> PixelData in
         return assert(pixel) ? PixelData.whitePixel : PixelData.blackPixel
      }
      return outImage
   }
}
/**
 * Type
 */
extension Splitter{
   internal typealias RGBUIImages = (r:Image,g:Image,b:Image)
   internal typealias RGBAImages = (r:RGBAImage,g:RGBAImage,b:RGBAImage)
   internal typealias OnOptionalChannelsComplete = (_ rgbaImages:RGBAImages?) -> Void
}
