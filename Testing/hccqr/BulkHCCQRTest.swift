import QR_lib
import QuartzCore
import CoreGraphics
import CoreImage

final class BulkHCCQRTest {}
/**
 * Read
 */
extension BulkHCCQRTest {
   static var startTime: Date = .init()
   /**
    * Test reading many HCCQR images on background threads
    */
   static func readingManyHCCQRImages() {
      // 🏀 ready to be tested 
      createManyHCCQRImages(onComplete: onCreateManyHCCQRImagesComplete)
   }
}
/**
 * Completion handler
 */
extension BulkHCCQRTest {
   /**
    * Called when all images are created
    */
   private static func onCreateManyHCCQRImagesComplete(images: [Image]) {
      var payloads: [Data?] = [Data?](repeating: nil, count: images.count)
      images.enumerated().forEach { arg in
         DispatchQueue.global(qos: .userInitiated).async {
            HCCQRReader.dataAndImages(image: arg.element) { result in
               DispatchQueue.main.async { // we need to go on the mainthread to manipulate array
                  onReadHCCQRImageComplete(i: arg .offset, result: result, payloads: &payloads)
               }
            }
         }
      }
   }
   /**
    * Called when a single hccqr image is read
    */
   private static func onReadHCCQRImageComplete(i: Int, result: Result<HCCQRReader.DataAndImages, Error>, payloads: inout [Data?]) {
      guard  let payload: Data = result.value() else { return }
      payloads[i] = payload
      if payloads.first(where: { $0 == nil }) == nil { // makes sure all images finished
         let payloads: [Data] = payloads.compactMap { $0 }
         _ = payloads
         Swift.print("Reading many HCCQR completed: \(abs(startTime.timeIntervalSinceNow))")
      }
   }
}
/**
 * Write
 */
extension BulkHCCQRTest {
   typealias OnCreateImagesComplete = (_ images: [Image]) -> Void
   /**
    * Tests the speed of creating hccqr images
    */
   private static func createManyHCCQRImages(onComplete:@escaping OnCreateImagesComplete) { // <- add typealais
      let config: QRConfig = (.v10, .byte, .l) // Config
      let randomData: [Data] = (0..<10).compactMap { _ in HCCQRStringData.randomData(config: config) } // Num of items to load
      var images: [Image?] = [Image?](repeating: nil, count: randomData.count)
      startTime = .init() // we start the clock here
      randomData.enumerated().forEach { arg in
         DispatchQueue.global(qos: .userInitiated).async { // Do stuff on bg thread
            HCCQRWriter.image(data: arg.element, multipliers: (moduleScale: 6, screenScale: 1), qrConfig: (config.version, config.ecLevel)) { result in
               onCreateHCCQRImageComplete(i: arg.offset, hccqrImage: try? result.get(), images: &images, onComplete: onComplete)
            }
         }
      }
   }
   /**
    * Create single HCCQR img complete
    */
   private static func onCreateHCCQRImageComplete(i: Int, hccqrImage: Image?, images: inout [Image?], onComplete:@escaping OnCreateImagesComplete) {
      guard let hccqrImage = hccqrImage else { fatalError("Unable to create hccqr image") }
      images[i] = hccqrImage
      if images.first(where: { $0 == nil }) == nil { // Make sure all images finish
         let images: [Image] = images.compactMap { $0 }
         Swift.print("Creating many HCCQR images completed: \(abs(startTime.timeIntervalSinceNow))")
         DispatchQueue.main.async { // - Fixme: ⚠️️ im not sure we need to jump on the main thread here
            onComplete(images)
            // Add the bellow when u add ImageView to repo
            // let imgView: UIImageView = .init(image: images[0])
            // self.view.addSubview(imgView)
         }
      }
   }
}
