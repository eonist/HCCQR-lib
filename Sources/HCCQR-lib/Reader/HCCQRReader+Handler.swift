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
    * 1. Get Data + Meta from two QR-Images
    * 2. Merge both Data payloads into one Data
    * 3. Call onComplete when both QR-Images are processed
    * - Important: ⚠️️ We split it into CIImages, because apples QRCode methods can only read ciimages
    * - Abstract: After splitting the HCCQRImage into color channels, we create QRImage layers of the color channels
    * - Fixme: ⚠️️⚠️️ Since the QR-Data is in the same spot across splitResult, Use the dataAndMeta and use the rect to crop the second ciImage, or buffer
    * - Fixme: ⚠️️⚠️️ You need to be able to support more than 2 layers aka 4 color-pallet
    * - Note: This code is really sync, but n the future it might be async
    * - Parameters:
    *   - result: Two QR-CImages (qrImg1: CIImage, qrImg2: CIImage)
    *   - onComplete: (Data, two qrImages)
    */
   static func onSplitComplete(result: Splitter.SplitResult, onComplete:@escaping DataAndImageCompleted) {
      guard let payload: Splitter.SplitPayload = result.value() else { onComplete(.failure(NSError("q1, q2 err \(result.errorStr)"))); return }
      let ciImages: [CIImage] = [payload.qrImg1, payload.qrImg2]
      var dataAndFrames: [QRReader.DataAndQuad?] = [QRReader.DataAndQuad?](repeating: nil, count: ciImages.count)
      // HCCQRReader.readQrTime = .init()
      // - Fixme: ⚠️️⚠️️⚠️️ This is where you add the crop code for the second QR image etc. Since it's on main, there is no speed loss etc
      DispatchQueue.main.async { // Has to be done on main thread, or else Apples.qrreader behaves bad
         ciImages.enumerated().forEach { item in
            // DispatchQueue.global(qos: .background).async {
            var err: Error?
            var dataAndQuad: QRReader.DataAndQuad?
            do { dataAndQuad = try QRReader.dataAndQuad(ciImage: item.element, useAccurateDetector: true) } catch { err = error } // Swift.print("colorSpace:  \(String(describing: item.element.colorSpace)) debugDescription:  \(item.element.debugDescription)")
            onReadQRCodeComplete(i: item.offset, ciIMG: item.element, dataAndQuad: dataAndQuad, error: err, dataAndQuads: &dataAndFrames, payload: payload, onComplete: onComplete)
             // }
         }
      }
   }
   /**
    * Makes sure all QR-Codes were read successfully
    * - Abstract: Completion handler (checks if all completions finished before calling complete on the whole process)
    * 1. Data and Meta-data comes in
    * 2. Add data and MetaData to array
    * 3. Return data, qrImgs and quad when array has zero nil's
    * - Fixme: ⚠️️ Group dataAndQuad and error into result
    * - Note: Can't be private, as other methods use it as well
    * - Parameters:
    *   - i: the index to store dataAndQuad
    *   - dataAndQuad: the item to insert into the result array
    *   - error: error from caller
    *   - dataAndFrames: result array
    *   - payload: 2 CIImage's
    *   - onComplete: completion block with DataAndImage
    */
   static func onReadQRCodeComplete(i: Int, ciIMG: CIImage, dataAndQuad: QRReader.DataAndQuad?, error: Error?, dataAndQuads: inout [QRReader.DataAndQuad?], payload: Splitter.SplitPayload, onComplete: DataAndImageCompleted ) {
      guard let dataAndFrame: QRReader.DataAndQuad = dataAndQuad else { onComplete(.failure(ReadError.unableToExtractQRData(msg: "QRIMG: \(i) error: \(String(describing: error?.localizedDescription))", ciImage: ciIMG))); return }
      dataAndQuads[i] = dataAndQuad
      if !dataAndQuads.contains (where: { $0 == nil }) { // Makes sure all images finished
         let data: Data = dataAndQuads.compactMap { $0?.qrData }.reduce(Data(), +) // Merges the data
         // readTime += abs(HCCQRReader.readQrTime.timeIntervalSinceNow); Swift.print("👉 Read QR complete: \(abs(HCCQRReader.readQrTime.timeIntervalSinceNow))")
         onComplete(.success((data, payload.qrImg1, payload.qrImg2, dataAndFrame.quad))) // Return the result here
      }
   }
}
