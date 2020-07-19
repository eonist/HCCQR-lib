import Foundation
import AVFoundation
import CoreImage
import CoreVideo
@testable import HCCQR_lib
import QR_lib

final class BufferTest {
   /**
    * HCCQR -> RGBAImage
    * 1. Creates random HCCQR-Data
    * 2. Creates HCCQR-Image based on HCCQR-Data
    * 3. Convert HCCQR-Image to RGBAImage data
    * 4. Read data from RGBAImage
    * 5. Verify that data is the same as original data
    *  - Note: We just compare the data payload here, since FileHasher is not added as a dep, it could be added, since this is just test code
    */
   static func test() -> Bool {
      let setup: HCCQRSetup = .init(qr: .init(qrVersion: .v4, ecLevel: .l), output: .init(scale: .init(6, 2), palette: .cp8()))
      guard let randomData = HCCQRStringData.randomData(setup: setup) else { Swift.print("unable to create data"); return false }
      guard let image: Image = try? Writer.image(data: randomData, config: setup) else { return false }
      Swift.print("hccqrImage.size:  \(image.size) scale:  \(image.scale)") //      Swift.print("hccqrImage.cgImage()?.width:  \(hccqrImage.cgImage?.width)")
//      guard let rgbaRep: RGBARep = try? BufferUtil.rgbaRep(image: image) else { Swift.print("err getting rgbImage"); return false }
      guard let buffer = try? BufferUtil.imageBuffer(image: image) else { Swift.print("err"); return false }
      do {
         // - Fixme: ⚠️️ add getter that creates bufferect from buffer, add to BufferRect type
         let size = CVImageBufferGetEncodedSize(buffer) // CVImageBufferGetDisplaySize, CVImageBufferGetCleanRect
         let crop: BufferRect = .init(0, 0, Int(size.width), Int(size.height))
         Swift.print("crop:  \(crop)")
         let payload: Reader.ReadPayload = try Reader.data(imageBuffer: buffer, crop: crop, scheme: .cs8)
//         let dataAndQuad: QRReader.DataAndQuad = try Reader.data(rgbaRep: rgbaRep, scheme: .cs8) // Convert RGBAImage to Data
//         Swift.print("dataAndQuad.qrData.count:  \(dataAndQuad.qrData.count)")
//         Swift.print("randomData.count:  \(randomData.count)")
         let isValid: Bool = randomData == payload.data
//         Swift.print("data?.count:  \(String(describing: dataAndQuad.qrData.count))")
         Swift.print("BufferTest isValid:  \(isValid ? "✅" : "🚫")")
         return isValid
      } catch {
         Swift.print("⚠️️ error:  \(error)")
         return false
      }
   }
}
