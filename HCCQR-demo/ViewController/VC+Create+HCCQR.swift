import UIKit
import QR_lib

extension ViewController {
   /**
    * test HCCQRImage creation (creates a single HCCQR image, then reads it)
    */
   func testCreatingHCCQRImage() {
      let startTime: Date = .init()
      let (qrVersion, qrMode, ecLevel): HCCQRConfig = (1, .byte, .l) // settings
      guard let randomString: String = HCCQRStringData.randomString(qrVersion: qrVersion, qrMode: qrMode, ecLevel: ecLevel) else { Swift.print("unable to create random string"); return }
//      Swift.print("randomString.count:  \(randomString.count)")
      guard let data: Data = randomString.data(using: .utf8) else { Swift.print("err"); return }
      createQR(data: data)
//      let hccqrVersion = HCCQRVersion.version(dataCount: data.count, qrMode: .byte, ecLevel: .l)
//      Swift.print("hccqrVersion:  \(String(describing: hccqrVersion))")
//      Swift.print("data.count:  \(data.count)")
      let createHCCQRTime: Date = .init()
      HCCQRWriter.image(data: data, moduleMultiplier: 6, scale: 1, qrConfig: (qrVersion, ecLevel)) { hccqrImage, error in // Create HCCQR from string
         self.onHCCQRWriteComplete(hccqrImage: hccqrImage, error: error, startTime: startTime, createHCCQRTime: createHCCQRTime, randomString: randomString)
      }
   }
   /**
    * Write complete (Created HCCQR image from string)
    */
   func onHCCQRWriteComplete(hccqrImage: Image?, error: Error?, startTime: Date, createHCCQRTime: Date, randomString: String) {
      Swift.print("hccqrImageComplete")
      guard let hccqrImage: Image = hccqrImage else { Swift.print("unable to create hccqr image \(String(describing: error?.localizedDescription))"); return }
      DispatchQueue.main.async {
         Swift.print("createHCCQRTime complete: \(abs(createHCCQRTime.timeIntervalSinceNow))")
         Swift.print("hccqrImage.scale:  \(hccqrImage.scale)")
         Swift.print("hccqrImage.size:  \(hccqrImage.size)")
         let imgView: UIImageView = .init(image: hccqrImage)
         self.view.addSubview(imgView) // Add image to view
         imgView.frame.origin.y = 0
      }
      let splitTime: Date = .init()
      HCCQRReader.dataAndImages(image: hccqrImage) { dataAndImages, error in // split the hccqrImg
         self.onHCCQRReadComplete(dataAndImages: dataAndImages, error: error, startTime: startTime, splitTime: splitTime, randomString: randomString)
      }
   }
   /**
    * Read complete (read data from HCCQRImage)
    */
   func onHCCQRReadComplete(dataAndImages: HCCQRReader.DataAndImages?, error: Error?, startTime: Date, splitTime: Date, randomString: String) {
      Swift.print("hccqrDataComplete")
      DispatchQueue.main.async {
         Swift.print("Seperation complete: \(abs(splitTime.timeIntervalSinceNow))")
         Swift.print("All done: \(abs(startTime.timeIntervalSinceNow))")
         guard let qr1Img = dataAndImages?.qr1 else { Swift.print("err qr1"); return }
         let img: UIImage = .init(ciImage: qr1Img)
         let imgView: UIImageView = .init(image: img)
         self.view.addSubview(imgView)
         imgView.frame.origin.y = 220
         //Swift.print("RGBAImage.initiatedCount:  \(RGBAImage.initiatedCount)")
         //Swift.print("RGBAImage.deInitiatedCount:  \(RGBAImage.deInitiatedCount)")
      }
      guard let payload: String = dataAndImages?.data?.stringUTF8 else { Swift.print("unable to get string from hccqr \(String(describing: error))"); return }
      let isMatching: Bool = randomString == payload // Assert payload
      Swift.print("isMatching:  \(isMatching ? "✅":"🚫")")
      // Ensure that img only has valid colors, aka no bluring
      //Swift.print("hasOnlyColorMap: \(ColorizeUtil.hasOnlyColorMap(uiImage:hccqrImage, colorMap: [.red,.green,.blue,.white]))")
   }
}
