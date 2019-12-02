import Foundation
import CoreImage
/**
 * Splitter
 */
internal class Splitter {
   /**
    * Returns two b&w qr imgs (by splittin an hccqr img)
    * - Fixme: ⚠️️ move the onCompositeComplete method to a priv class scoped method
    */
   internal static func split(uiImage: Image, onComplete:@escaping SplitPayloadComplete) {
      let onChannelsComplete:(_ channels: RGBAImages?) -> Void = { channels in
         guard let channels: RGBAImages = channels else { Swift.print("Splitter.split - Unable to create rgbaImgs"); onComplete(nil); return }//(r,g,b)
         let channelArr: [(first: RGBAImage, second: RGBAImage)] = [(channels.b, channels.g), (channels.r, channels.b)]
         var qrImgs: [CIImage?] = [CIImage?](repeating: nil, count: channelArr.count)
         func onCompositeComplete(i: Int, qrImg: CIImage?) {
            guard let qrImg: CIImage = qrImg else { Swift.print("Splitter.split() onCompositeComplete() - no qrImg"); [channels.r, channels.g, channels.b].forEach { $0.deinitiate() }; onComplete(nil); return }
            qrImgs[i] = qrImg/*it matters which order the qrImages came in when you stitch them back together*/
            if qrImgs.first(where: { $0 == nil }) == nil {/*makes sure all images finished*/
               [channels.r, channels.g, channels.b].forEach { $0.deinitiate() }/*Or else we get mem leak*/ /*Swift.print("Splitter.split() - deallocate")*/ 
               let qrImages: [CIImage] = qrImgs.compactMap { $0 }
               onComplete((qrImages[0], qrImages[1]))
            }
         }
         channelArr.enumerated().forEach { channel in
            DispatchQueue.global(qos: .userInitiated).async {
               let qrImg: CIImage? = Compositor.composite(first: channel.element.first, second: channel.element.second/*, scale: uiImage.scale*/)
               DispatchQueue.main.async {
                  onCompositeComplete(i: channel.offset, qrImg: qrImg)
               }
            }
         }
      }
      channels(image: uiImage, onComplete: onChannelsComplete)/*Get RGBAImages from UIImages*/
   }
}
