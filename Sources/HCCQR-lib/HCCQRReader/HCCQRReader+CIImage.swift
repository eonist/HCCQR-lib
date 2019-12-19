import Foundation
import QR_lib
import QuartzCore
import CoreImage

extension HCCQRReader {
   /**
    * Creates data for HCCQQR image
    * - Fixme: ⚠️️ Consider changing image to CGImage, as that is what is used in the end, could make thing faster
    * - Fixme: ⚠️️ When the first QRImage Quad is found, the subsequent QR-Rects will be in the same quadrant, clip the subsequent images
    */
   public static func dataAndImages(ciImage: CIImage, onComplete:@escaping DataAndImageCompleted) {
      //      Swift.print("dataAndImages")
      let onSplitComplete: Splitter.SplitPayloadCompleted = { result in
         //         Swift.print("onSplitComplete")
         guard let payload: Splitter.SplitPayload = result.value() else { onComplete(.failure(NSError("q1, q2 err \(result.errorStr)"))); return }
         let ciImages: [CIImage] = [payload.qrImg1, payload.qrImg2]
         var dataAndFrames: [QRReader.DataAndQuad?] = [QRReader.DataAndQuad?](repeating: nil, count: ciImages.count)
         ciImages.enumerated().forEach { item in
            DispatchQueue.main.async { // Has to be done on main thread, or else Apples.qrreader behaves bad
               guard let dataAndQuad: QRReader.DataAndQuad = try? QRReader.dataAndQuad(ciImage: item.element) else { onQRCodeComplete(i: item.offset, dataAndQuad: nil, error: NSError(domain: "unable to get DataAndQuad", code: 0), dataAndFrames: &dataAndFrames, payload: payload, onComplete: onComplete); return }// - Fixme: ⚠️️ why not just throw? }
               onQRCodeComplete(i: item.offset, dataAndQuad: dataAndQuad, error: nil, dataAndFrames: &dataAndFrames, payload: payload, onComplete: onComplete)
            }
         }
      }
      Splitter.split(ciImage: ciImage, onComplete: onSplitComplete) // Start the splitting process
   }
}
