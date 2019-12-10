import Foundation
import QR_lib
import QuartzCore
import CoreImage
/**
 * Image -> String
 */
public final class HCCQRReader {
   /**
    * Creates data for HCCQQR image
    * - Fixme: ⚠️️ Consider changing image to CGImage, as that is what is used in the end, could make thing faster
    * - Fixme: ⚠️️ Simplify this method
    * - Fixme: ⚠️️ When the first QRImage Quad is found, the subsequent QR-Rects will be in the same quadrant, clip the subsequent images
    */
   public static func dataAndImages(image: Image, onComplete:@escaping DataAndImageComplete) {
      let onSplitComplete: Splitter.SplitPayloadComplete = { payload in
         guard let payload: Splitter.SplitPayload = payload else { onComplete(nil, "HCCQRUtil.dataAndImages() - q1, q2 err"); return }
         let ciImages: [CIImage] = [payload.qrImg1, payload.qrImg2]
         var dataAndFrames: [QRReader.DataAndQuad?] = [QRReader.DataAndQuad?](repeating: nil, count: ciImages.count)
         ciImages.enumerated().forEach { item in
            DispatchQueue.main.async { // Has to be done on main thread, or else Apples.qrreader behaves bad
               // - Fixme: ⚠️️ You can use try? guard on the bellow blocks, maybe
               do {
                  let dataAndQuad: QRReader.DataAndQuad = try QRReader.dataAndQuad(ciImage: item.element)
                  onQRCodeComplete(i: item.offset, dataAndQuad: dataAndQuad, error: nil, dataAndFrames: &dataAndFrames, payload: payload, onComplete: onComplete)
               } catch {
                  onQRCodeComplete(i: item.offset, dataAndQuad: nil, error: error, dataAndFrames: &dataAndFrames, payload: payload, onComplete: onComplete) // - Fixme: ⚠️️ why not just throw?
               }
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
    */
   private static func onQRCodeComplete(i: Int, dataAndQuad: QRReader.DataAndQuad?, error: Error?, dataAndFrames: inout [QRReader.DataAndQuad?], payload: Splitter.SplitPayload, onComplete: DataAndImageComplete ) {
      guard let dataAndFrame: QRReader.DataAndQuad = dataAndQuad else { onComplete((nil, payload.qrImg1, payload.qrImg2, nil), "HCCQRStringUtil.dataAndImages() - ⚠️️ Unable to get dataAndFrame for QRIMG: \(i)⚠️️ \(String(describing: error?.localizedDescription))" ); return }
      dataAndFrames[i] = dataAndQuad
      if dataAndFrames.first(where: { $0 == nil }) == nil { // Makes sure all images finished
         let d: Data = dataAndFrames.compactMap { $0?.qrData }.reduce(Data(), +)
         onComplete((d, payload.qrImg1, payload.qrImg2, dataAndFrame.quad), nil) // Return the result here
      }
   }
}
/**
 * Extra
 */
extension HCCQRReader {
   /**
    * Creates data for HCCQQR image, and frame
    * - Fixme: ⚠️️ group data and frame into a result: (frame, data) tuple
    * - Fixme: ⚠️️ make this use Result type
    */
   public static func dataAndQuad(image: Image, onComplete:@escaping OnGetDataAndFrameCompleted) {
      let completion: DataAndImageComplete = { dataAndImages, error in
         guard let dataAndImages: DataAndImages = dataAndImages else { onComplete(.failure(error!)); return }
         guard let data: Data = dataAndImages.data else { onComplete(.failure(NSError(domain: "Unable to get data \(error!.localizedDescription)", code: 0))); return }
         guard let quad: QRReader.Quad = dataAndImages.quad else { onComplete(.failure(NSError(domain: "Unable to get quad \(error!.localizedDescription)", code: 0))); return }
         onComplete(.success((data, quad)))
      }
      dataAndImages(image: image, onComplete: completion)
   }
   /**
    * Creates data for HCCQR image
    */
   public static func data(image: Image, onComplete:@escaping OnHCCQRDataComplete) {
      dataAndImages(image: image) { dataAndImages, error in onComplete(dataAndImages?.data, error) }
   }
}
