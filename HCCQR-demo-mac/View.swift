import Cocoa
import QR_lib

open class View: NSView {
   override open var isFlipped: Bool { true } // TopLeft orientation
   override public init(frame: CGRect) {
      super.init(frame: frame)
      Swift.print("hello world")
      self.wantsLayer = true // if true then view is layer backed
      testHCCQR()
   }
   /**
    * Boilerplate
    */
   public required init?(coder decoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
}
/**
 * Read test
 */
extension View {
   /**
    * Visual and Syntetic write / read HCCQR
    */
   func testHCCQR() {
      Swift.print("testHCCQR")
      let setup: HCCQRConfig = {
         let qrSetup: QRSetup = .init(qrVersion: .v4, ecLevel: .l)
         let output: OutputConfig = .init(scale: .init(6, 2), cType: .c4)
         return .init(qr: qrSetup, output: output)
      }()
      guard let randomData: Data = HCCQRData.randomData(setup: setup) else { return }
      //      let coreCount: Int = ProcessInfo().activeProcessorCount
      //      print("coreCount \(coreCount)")
      guard let img: Image = try? Writer.image(data: randomData, config: setup, parallel: true) else { return }
      Swift.print("img.size:  \(img.size)")
      //      guard let buffer: CVImageBuffer = try? BufferUtil.imageBuffer(image: img) else { Swift.print("unable to get buffer"); return }
      //      let image = BufferUtil.image(imageBuffer: buffer, scale: setup.scale.screen)
      //      Swift.print("image.size:  \(image.size)")
      let imgView: NSImageView = .init(frame: .init(origin: .zero, size: img.size))
      imgView.image = img
      self.addSubview(imgView)
      _ = {
         do {
            let dataAndQuad: QRReader.DataAndQuad = try HCCQRReader.data(image: img, scheme: setup.cType.cs, parallel: true)
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
