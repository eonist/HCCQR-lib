import QR_lib
import QuartzCore
import CoreGraphics
import CoreImage
@testable import HCCQR_lib

extension BulkHCCQRTest {
   /**
    * Write many HCCQR images
    *  ## Examples:
    * creatingManyHCCQRImages(onComplete: { images in Swift.print("images.count:  \(images.count)") } )
    */
   static func writeMany(onComplete:@escaping OnWriteImagesComplete) {
      Swift.print("writeHCCQRImages")
      let config: QRConfig = (.v6, .byte, .l) // Config (app uses 4 to 10)
      let randomData: [Data] = (0..<10).compactMap { _ in HCCQRStringData.randomData(config: config) } // Num of items to load
      var images: [RGBAImage?] = [RGBAImage?](repeating: nil, count: randomData.count)//      var images: [CIImage?] = [CIImage?](repeating: nil, count: randomData.count)
      writeTime = .init() // we start the write clock here (random data creation time isn't interesting)
      totalTime = .init()
      randomData.enumerated().forEach { arg in
         HCCQRWriter.rgbaImage(data: arg.element, multipliers: (moduleScale: 6, screenScale: 2), qrConfig: (config.version, config.ecLevel)) { result in
//            Swift.print("ciimg done: \(try? result.get().size)")
            onWriteComplete(i: arg.offset, rgbaImage: try? result.get(), images: &images, onComplete: onComplete)
         }
      }
   }
   /**
    * Read many
    */
   static func readMany(rgbaImages: [RGBAImage], onComplete:@escaping OnReadImagesComplete) {
      Swift.print("readHCCQRImages")
      var payloads: [Data?] = [Data?](repeating: nil, count: rgbaImages.count)
      rgbaImages.enumerated().forEach { arg in // the calles are async, and will finish randomly
         DispatchQueue.global(qos: .userInitiated).async {
            HCCQRReader.dataAndImages(rgbaImage: arg.element) { result in  // split the hccqrImg
               DispatchQueue.main.async { // We need to go on the mainthread to manipulate array
                  onReadComplete(i: arg.offset, result: result, payloads: &payloads, onComplete: onComplete)
               }
            }
         }
      }
   }
}
