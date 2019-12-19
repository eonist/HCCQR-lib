import Foundation
import QR_lib
import QuartzCore
import CoreImage
/**
 * Image -> String
 */
public final class HCCQRReader {
   /**
    * Creates data for HCCQQR image, and frame (Has support for Quad)
    */
   public static func dataAndQuad(image: Image, onComplete:@escaping OnGetDataAndQuadCompleted) {
      let completion: DataAndImageCompleted = { result in
         guard let dataAndImages: DataAndImages = result.value() else { onComplete(.failure(result.getError())); return }
         guard let data: Data = dataAndImages.data else { onComplete(.failure(NSError("Unable to get data \(result.errorStr)"))); return }
         guard let quad: QRReader.Quad = dataAndImages.quad else { onComplete(.failure(NSError("Unable to get quad \(result.errorStr)"))); return }
         onComplete(.success((data, quad)))
      }
      dataAndImages(image: image, onComplete: completion)
   }
   /**
    * Creates data for HCCQQR image
    * - Fixme: ⚠️️ Consider changing image to CGImage, as that is what is used in the end, could make thing faster
    * - Fixme: ⚠️️ When the first QRImage Quad is found, the subsequent QR-Rects will be in the same quadrant, clip the subsequent images
    */
   public static func dataAndImages(image: Image, onComplete:@escaping DataAndImageCompleted) {
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
      Splitter.split(uiImage: image, onComplete: onSplitComplete) // Start the splitting process
   }
}
/**
 * Private static helper
 */
extension HCCQRReader {
   /**
    * completion handler
    * - Fixme: ⚠️️ group dataAndQuad and error into result
    */
   /*private */static func onQRCodeComplete(i: Int, dataAndQuad: QRReader.DataAndQuad?, error: Error?, dataAndFrames: inout [QRReader.DataAndQuad?], payload: Splitter.SplitPayload, onComplete: DataAndImageCompleted ) {
      guard let dataAndFrame: QRReader.DataAndQuad = dataAndQuad else { onComplete(.failure(NSError(domain: "Unable to get dataAndFrame for QRIMG: \(i) error: \(String(describing: error?.localizedDescription))", code: 0))); return }
      dataAndFrames[i] = dataAndQuad
      if dataAndFrames.first(where: { $0 == nil }) == nil { // Makes sure all images finished
         let data: Data = dataAndFrames.compactMap { $0?.qrData }.reduce(Data(), +) // merges the data
         onComplete(.success((data, payload.qrImg1, payload.qrImg2, dataAndFrame.quad))) // Return the result here
      }
   }
}
/**
 * Creates data for HCCQR image
 */
//   private static func data(image: Image, onComplete:@escaping OnHCCQRDataComplete) {
//      dataAndImages(image: image) { result in onComplete(try? result.get().data, result.error()) }
//   }
