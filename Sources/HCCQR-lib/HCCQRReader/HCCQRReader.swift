import Foundation
import QR_lib
import QuartzCore
import CoreImage
/**
 * Image -> String
 */
public class HCCQRReader {
   /**
    * Creates data for HCCQQR image
    * - Fixme: ⚠️️ Consider changing image to CGImage, as that is what is used in the end
    * - Fixme: Simplify this method
    */
   public static func dataAndImages(image: Image, onComplete:@escaping DataAndImageComplete) {
      let onSplitComplete:(_ payload: Splitter.SplitPayload?) -> Void = { payload in
         guard let payload: Splitter.SplitPayload = payload else { onComplete(nil, "HCCQRUtil.dataAndImages() - q1,q2 err"); return }
         let (q1, q2): (CIImage, CIImage) = payload
         let ciImages: [CIImage] = [q1, q2]
         var dataAndFrames: [QRReader.DataAndFrame?] = [QRReader.DataAndFrame?](repeating: nil, count: ciImages.count)
         func onQRCodeComplete(i: Int, dataAndFrame: QRReader.DataAndFrame?, error: Error?) {
            guard let dataAndFrame: QRReader.DataAndFrame = dataAndFrame else { onComplete((nil, q1, q2, nil), "HCCQRStringUtil.dataAndImages() - ⚠️️ Unable to get dataAndFrame for QRIMG: \(i)⚠️️ \(String(describing: error?.localizedDescription))" ); return }
            dataAndFrames[i] = dataAndFrame
            if dataAndFrames.first(where: { $0 == nil }) == nil {/*Makes sure all images finished*/
               let d: Data = dataAndFrames.compactMap { $0?.qrData }.reduce(Data(), +)
               onComplete((d, q1, q2, dataAndFrame.qrFrame), nil)/*Return the result here*/
            }
         }
         ciImages.enumerated().forEach { item in
            DispatchQueue.main.async {/*Has to be done on main thread, or else Apples.qrreader behaves bad*/
               do {
                  let dataAndFrame: QRReader.DataAndFrame = try QRReader.dataAndFrame(ciImage: item.element)
                  onQRCodeComplete(i: item.offset, dataAndFrame: dataAndFrame, error: nil)
               } catch {
                  onQRCodeComplete(i: item.offset, dataAndFrame: nil, error: error)
               }
            }
         }
      }
      Splitter.split(uiImage: image, onComplete: onSplitComplete ) /*Start the splitting process*/
   }
}
/**
 * Extra
 */
extension HCCQRReader {
   /**
    * Creates data for HCCQQR image, and frame
    * Fixme: ⚠️️ group data and frame into a result:(frame,data) tuple
    */
   public static func dataAndFrame(image: Image, onComplete:@escaping OnGetDataAndFrameComplete) {
      let completion: DataAndImageComplete = { dataAndImages, error in
         guard let dataAndImages = dataAndImages else { onComplete(nil, nil, error); return }
         guard let data: Data = dataAndImages.data else { onComplete(nil, nil, "HCCQRStringUtil.dataAndFrame() - Unable to get data \(String(describing: error?.localizedDescription))"); return }
         guard let frame: CGRect = dataAndImages.frame else { onComplete(nil, nil, "HCCQRStringUtil.dataAndFrame() - Unable to get data \(String(describing: error?.localizedDescription))"); return }
         onComplete(data, frame, nil)
      }
      dataAndImages(image: image, onComplete: completion)
   }
   /**
    * Creates data for HCCQQR image
    */
   public static func data(image: Image, onComplete:@escaping OnHCCQRDataComplete) {
      dataAndImages(image: image) { dataAndImages, error in onComplete(dataAndImages?.data, error) }
   }
}
