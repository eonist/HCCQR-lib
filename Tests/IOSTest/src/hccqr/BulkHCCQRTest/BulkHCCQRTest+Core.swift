import QR_lib
import QuartzCore
import CoreGraphics
import CoreImage
@testable import HCCQR_lib

extension BulkHCCQRTest {
   /**
    * Write many
    *  ## Examples:
    * creatingManyHCCQRImages(onComplete: { images in Swift.print("images.count:  \(images.count)") } )
    */
   static func writeHCCQRImages(onComplete:@escaping OnWriteImagesComplete) {
      let config: QRConfig = (.v10, .byte, .l) // Config
      let randomData: [Data] = (0..<10).compactMap { _ in HCCQRStringData.randomData(config: config) } // Num of items to load
      var images: [Image?] = [QR_lib.Image?](repeating: nil, count: randomData.count)
      writeTime = .init() // we start the write clock here (random data creation time isn't interesting)
      randomData.enumerated().forEach { arg in
         HCCQRWriter.image(data: arg.element, multipliers: (moduleScale: 6, screenScale: 1), qrConfig: (config.version, config.ecLevel)) { result in
            onCreateHCCQRImageComplete(i: arg.offset, hccqrImage: try? result.get(), images: &images, onComplete: onComplete)
         }
      }
   }
   /**
    * Read many
    */
   static func readHCCQRImages(images: [Image], onComplete:@escaping OnReadImagesComplete) {
      Swift.print("readHCCQRImages:  \(images.count)")
      var payloads: [Data?] = [Data?](repeating: nil, count: images.count)
      images.enumerated().forEach { arg in
         DispatchQueue.global(qos: .userInitiated).async {
            Swift.print("arg.offset:  \(arg.offset)")
            HCCQRReader.dataAndImages(image: arg.element) { result in
               Swift.print("read")
               DispatchQueue.main.async { // we need to go on the mainthread to manipulate array
                  onReadHCCQRImageComplete(i: arg.offset, result: result, payloads: &payloads, onComplete: onComplete)
               }
            }
         }
      }
   }
}
