import Foundation
import QR_lib
import QuartzCore
import CoreImage
/**
 * Static handlers
 */
extension HCCQRReader {
   /**
    * onSplitComplete
    * 1. Get Data+Meta from two QR-Images
    * 2. Merge both Data payloads into one Data
    * 3. Call onComplete When both QR-Images are processed
    * - Important: ⚠️️ We split it into CIImages, because apples QRCode methods can only read ciimages
    * - Abstract: After splitting the HCCQRImage into color channels, we create QRImage layers of the color channels
    * - Fixme: ⚠️️ Since the QR-Data is in the same spot across splitResult, Use the dataAndMeta and use the rect to crop the second ciImage, or buffer
    * - Parameters:
    *   - result: (qrImg1: CIImage, qrImg2: CIImage)
    *   - onComplete: (2 qrImages and Data)
    */
   static func onSplitComplete(result: Splitter.SplitResult, onComplete:@escaping DataAndImageCompleted) {
      guard let payload: Splitter.SplitPayload = result.value() else { onComplete(.failure(NSError("q1, q2 err \(result.errorStr)"))); return }
      let ciImages: [CIImage] = [payload.qrImg1, payload.qrImg2]
      var dataAndFrames: [QRReader.DataAndQuad?] = [QRReader.DataAndQuad?](repeating: nil, count: ciImages.count)
      // HCCQRReader.readQrTime = .init()
      DispatchQueue.main.async { // Has to be done on main thread, or else Apples.qrreader behaves bad
         ciImages.enumerated().forEach { item in
            // DispatchQueue.global(qos: .background).async {
            var err: Error?
            var dataAndQuad: QRReader.DataAndQuad?
            do { dataAndQuad = try QRReader.dataAndQuad(ciImage: item.element, useAccurateDetector: true) } catch { err = error } // Swift.print("colorSpace:  \(String(describing: item.element.colorSpace)) debugDescription:  \(item.element.debugDescription)")
            onQRCodeComplete(i: item.offset, dataAndQuad: dataAndQuad, error: err, dataAndFrames: &dataAndFrames, payload: payload, onComplete: onComplete)
             //}
         }
      }
   }
   /**
    * Completion handler (checks if all completions finished before calling complete on the whole process)
    * Write step documentation 🏀
    * - Fixme: ⚠️️ Group dataAndQuad and error into result
    * - Fixme: ⚠️️ Rename dataAndFrames to dataAndQuads
    * - Note: Can't be private, as other methods use it as well
    * - Parameters:
    *   - i: the index to store dataAndQuad
    *   - dataAndQuad: the item to insert into the result array
    *   - error: error from caller
    *   - dataAndFrames: result array
    *   - payload: 2 CIImage's
    *   - onComplete: completion block with DataAndImage
    */
   static func onQRCodeComplete(i: Int, dataAndQuad: QRReader.DataAndQuad?, error: Error?, dataAndFrames: inout [QRReader.DataAndQuad?], payload: Splitter.SplitPayload, onComplete: DataAndImageCompleted ) {
      guard let dataAndFrame: QRReader.DataAndQuad = dataAndQuad else { onComplete(.failure(NSError(domain: "HCCQRReader.onQRCodeComplete() - Unable to get dataAndFrame for QRIMG: \(i) error: \(String(describing: error?.localizedDescription))", code: 0))); return }
      dataAndFrames[i] = dataAndQuad
      if dataAndFrames.first(where: { $0 == nil }) == nil { // Makes sure all images finished
         let data: Data = dataAndFrames.compactMap { $0?.qrData }.reduce(Data(), +) // Merges the data
         // readTime += abs(HCCQRReader.readQrTime.timeIntervalSinceNow); Swift.print("👉 Read QR complete: \(abs(HCCQRReader.readQrTime.timeIntervalSinceNow))")
         onComplete(.success((data, payload.qrImg1, payload.qrImg2, dataAndFrame.quad))) // Return the result here
      }
   }
}
