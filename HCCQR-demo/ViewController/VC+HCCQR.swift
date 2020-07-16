import UIKit
import QR_lib
/**
 * Read test
 */
extension ViewController {
   /**
    * Visual and Syntetic write / read HCCQR
    */
   func testHCCQR() {
      let setup: HCCQRSetup = {
         let qrSetup: QRSetup = .init(qrVersion: .v1, ecLevel: .l)
         let output: OutputConfig = .init(scale: (6, 2), map: .cp16(useDarkMode: false))
         return .init(qr: qrSetup, output: output)
      }()
      guard let randomData: Data = HCCQRStringData.randomData(setup: setup) else { return }
      //      let coreCount: Int = ProcessInfo().activeProcessorCount
      //      print("coreCount \(coreCount)")
      guard let img: Image = try? Writer.img(data: randomData, config: setup/*, coreCount: coreCount*/) else { return }
      let imgView: UIImageView = .init(image: img)
      self.view.addSubview(imgView)
      _ = {
         do {
            let dataAndQuad: QRReader.DataAndQuad = try Reader.data(image: img, pallete: ._8)
            let isValid: Bool = randomData == dataAndQuad.qrData
            Swift.print("data?.count:  \(String(describing: dataAndQuad.qrData.count))")
            Swift.print("isValid:  \(isValid ? "✅" : "🚫")")
         } catch {
            Swift.print("error:  \(error)")
         }
      }()
      _ = {
         let data: Data? = try? Reader.data(image: img, pallete: ._16).qrData
         let isValid: Bool = randomData == data
         Swift.print("data?.count:  \(String(describing: data?.count))")
         Swift.print("isValid:  \(isValid ? "✅" : "🚫")")
      }
   }
}
