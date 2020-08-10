import Foundation
import AVFoundation
import CoreImage
import CoreVideo
@testable import HCCQR_lib
import QR_lib
import TimeMeasure

final class BufferTest {
   static let cType: CType = .c8 // the mappings for writing / reading
   static let setup: HCCQRSetup = {
      let qrSetup: QRSetup = .init(qrVersion: .v4, ecLevel: .l)
      let output: OutputConfig = .init(scale: .init(6, 2), cType: cType)
      return .init(qr: qrSetup, output: output)
   }()
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
      guard let randomData = HCCQRStringData.randomData(setup: setup) else { Swift.print("unable to create data"); return false }
      guard let buffer: CVImageBuffer = write(data: randomData) else { return false }
      let (isValid, time): (Bool, Double) = TimeMeasure.timeElapsed {
         read(buffer: buffer, data: randomData)
      }
      Swift.print("read time:  \(time)")
      Swift.print("BufferTest isValid:  \(isValid ? "✅" : "🚫")")
      return isValid
   }
}
extension BufferTest {
   /**
    * Write (Data -> Image -> Buffer)
    */
   private static func write(data: Data) -> CVImageBuffer? {
      guard let image: Image = try? Writer.image(data: data, config: setup, parallel: true) else { return nil }
      //      Swift.print("hccqrImage.size:  \(image.size) scale:  \(image.scale)") //      Swift.print("hccqrImage.cgImage()?.width:  \(hccqrImage.cgImage?.width)")
//      guard let rgbaRep: RGBARep = try? BufferUtil.rgbaRep(image: image) else { Swift.print("err getting rgbImage"); return false }
      return try? BufferUtil.imageBuffer(image: image)
   }
   /**
    * Read (Buffer -> Data)
    */
   private static func read(buffer: CVImageBuffer, data: Data) -> Bool {
      do {
         // let size = CVImageBufferGetEncodedSize(buffer) // CVImageBufferGetDisplaySize, CVImageBufferGetCleanRect
         let payload: Reader.ReadPayload = try Reader.data(imageBuffer: buffer, crop: buffer.rect, scheme: cType.cs, parallel: true)
         // let dataAndQuad: QRReader.DataAndQuad = try Reader.data(rgbaRep: rgbaRep, scheme: .cs8) // Convert RGBAImage to Data
         // Swift.print("dataAndQuad.qrData.count:  \(dataAndQuad.qrData.count)")
          Swift.print("randomData.count:  \(data.count)")
          Swift.print("data?.count:  \(String(describing: payload.data.count))")
         let isValid: Bool = data == payload.data
         print("\(isValid)")
         return isValid
      } catch {
         Swift.print("⚠️️ error:  \(error)")
         return false
      }
   }
}
