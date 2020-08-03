import UIKit
import QR_lib
/**
 * Read test
 */
extension ViewController {
   static let (pallete, scheme): (ColorPalette, ChannelScheme) = (CType.c4.cp(), CType.c4.cs) // the mappings for writing / reading
   /**
    * Visual and Syntetic write / read HCCQR
    */
   func testHCCQR() {
      Swift.print("testHCCQR")
      let setup: HCCQRSetup = {
         let qrSetup: QRSetup = .init(qrVersion: .v1, ecLevel: .l)
         let output: OutputConfig = .init(scale: .init(6, 2), palette: Self.pallete)
         return .init(qr: qrSetup, output: output)
      }()
      guard let randomData: Data = HCCQRStringData.randomData(setup: setup) else { return }
      //      let coreCount: Int = ProcessInfo().activeProcessorCount
      //      print("coreCount \(coreCount)")
      guard let img: Image = try? Writer.image(data: randomData, config: setup, parallel: true) else { return }
      Swift.print("img.size:  \(img.size)")
//      guard let buffer: CVImageBuffer = try? BufferUtil.imageBuffer(image: img) else { Swift.print("unable to get buffer"); return }
//      let image = BufferUtil.image(imageBuffer: buffer, scale: setup.scale.screen)
//      Swift.print("image.size:  \(image.size)")
      let imgView: UIImageView = .init(image: img)
      self.view.addSubview(imgView)
      _ = {
         do {
            let dataAndQuad: QRReader.DataAndQuad = try Reader.data(image: img, scheme: Self.scheme, parallel: true)
            let isValid: Bool = randomData == dataAndQuad.qrData
            Swift.print("data?.count:  \(String(describing: dataAndQuad.qrData.count))")
            Swift.print("isValid:  \(isValid ? "✅" : "🚫")")
         } catch {
            Swift.print("error:  \(error)")
         }
      }()
//      _ = {
//         let data: Data? = try? Reader.data(image: image, scheme: .cs16).qrData
//         let isValid: Bool = randomData == data
//         Swift.print("data?.count:  \(String(describing: data?.count))")
//         Swift.print("isValid:  \(isValid ? "✅" : "🚫")")
//      }
   }
}
