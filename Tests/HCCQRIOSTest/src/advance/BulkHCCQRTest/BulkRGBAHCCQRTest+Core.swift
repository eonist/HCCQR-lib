import QR_lib
import QuartzCore
import CoreGraphics
import CoreImage
@testable import HCCQR_lib

extension BulkRGBAHCCQRTest {
   /**
    * Write many HCCQR images
    * ## Examples:
    * creatingManyHCCQRImages(onComplete: { images in Swift.print("images.count:  \(images.count)") } )
    */
   static func writeMany(onComplete:@escaping OnWriteImagesComplete) {
      let config: QRConfig = (.v6, .byte, .l) // Config (app uses 4 to 10)
      let randomData: [Data] = (0..<100).compactMap { _ in HCCQRStringData.randomData(config: config) } // Num of items to load
      var images: [RGBARep?] = [RGBARep?](repeating: nil, count: randomData.count)//      var images: [CIImage?] = [CIImage?](repeating: nil, count: randomData.count)
      writeTime = .init() // we start the write clock here (random data creation time isn't a part of the benchmark)
      totalTime = .init()
      randomData.enumerated().forEach { arg in
         Writer.rgbaImage(data: arg.element, multipliers: (module: 6, screen: 2), qrConfig: (config.version, config.ecLevel)) { result in
            onWriteComplete(i: arg.offset, rgbaImage: try? result.get(), images: &images, onComplete: onComplete)
         }
      }
   }
   /**
    * Read many
    */
   static func readMany(rgbaImages: [RGBARep], onComplete:@escaping OnReadImagesComplete) {
      var payloads: [Data?] = [Data?](repeating: nil, count: rgbaImages.count)
      rgbaImages.enumerated().forEach { arg in // the calles are async, and will finish randomly
//         DispatchQueue.global(qos: .background).async { // ⚠️️ seems 🤔 to fail if this is put on a bg thread, it doesnt provide any speed benfit either
            Reader.dataAndImages(rgbaImage: arg.element) { result in  // split the hccqrImg
               DispatchQueue.main.async { // We need to go on the mainthread to manipulate array
                  onReadComplete(i: arg.offset, result: result, payloads: &payloads, onComplete: onComplete)
               }
            }
//         }
      }
   }
}
