import Cocoa
import QR_lib
/**
 * Tests
 */
extension View {
   /**
    * test HCCQRImage creation
    */
   func testCreatingHCCQRImage(onComplete:@escaping (NSImage) -> Void) {
      //      fatalError("⚠️️ out of order")
      let startTime: Date = .init()
      let (qrVersion, qrMode, ecLevel): (Int, QRMode, ECLevel) = (1, .byte, .l)//settings
      guard let randomString = HCCQRStringData.randomString(qrVersion: qrVersion, qrMode: qrMode, ecLevel: ecLevel) else { Swift.print("unable to create random string"); return }
      guard let data = randomString.data(using: .utf8) else { Swift.print("unable to create data"); return }
      let createHCCQRTime: Date = .init()
      let hccqrImageComplete: OnHCCQRImageComplete = { hccqrImage, error in
         guard let hccqrImage = hccqrImage else { Swift.print("unable to create hccqr image \(String(describing: error))"); return }
         DispatchQueue.main.async {
            Swift.print("hccqrImage.size:  \(hccqrImage.size)")
            Swift.print("createHCCQRTime complete: \(abs(createHCCQRTime.timeIntervalSinceNow))")
            onComplete(hccqrImage)
         }
         let splitTime: Date = .init()
         let hccqrDataComplete: OnHCCQRDataComplete = { data, error  in
            guard let payload: String = data?.stringUTF8 else { Swift.print("unable to get string from hccqr\(error.debugDescription)"); return }
            /*⭐ 3. Assert payload ⭐*/
            let isMatching: Bool = randomString == payload
            Swift.print("isMatching:  \(isMatching ? "✅":"🚫")")
            DispatchQueue.main.async {
               Swift.print("Seperation complete: \(abs(splitTime.timeIntervalSinceNow))")
               Swift.print("Read and write done: \(abs(startTime.timeIntervalSinceNow))")
            }
            /*ensure that img only has valid colors, akak no bluring*/
            //Swift.print("hasOnlyColorMap: \(ColorizeUtil.hasOnlyColorMap(uiImage:hccqrImage, colorMap: [.red,.green,.blue,.white]))")
         }
         DispatchQueue.global(qos: .userInitiated).async {
            /*⭐ 2. try split the hccqrImg ⭐*/
            HCCQRReader.data(image: hccqrImage, onComplete: hccqrDataComplete)
         }
      }
      DispatchQueue.global(qos: .userInitiated).async {
         /*⭐ 1. Create HCCQR from string ⭐*/
         HCCQRWriter.image(data: data, moduleMultiplier: 6, scale: 2, qrConfig: (qrVersion, ecLevel), onComplete: hccqrImageComplete)
      }
   }
}
