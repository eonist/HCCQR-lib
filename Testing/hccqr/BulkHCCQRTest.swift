import QR_lib
import QuartzCore
import CoreGraphics
import CoreImage

final class BulkHCCQRTest {}
/**
 * Read
 */
extension BulkHCCQRTest {
   /**
    * Test reading many HCCQR images on background threads
    */
   static func readingManyHCCQRImages() {
      print("⚠️️ out of order")
      let startTime: Date = .init()
      func onImageCreationComplete(images: [Image]) {
         var payloads: [String?] = [String?](repeating: nil, count: images.count)
         func readHCCQRComplete(i: Int, payload: String?) {
            guard let payload: String = payload else { Swift.print("unable to get string from hccqr"); return }
            Swift.print("payload.count:  \(payload.count)")
            payloads[i] = payload
            if payloads.first(where: { $0 == nil }) == nil { /*makes sure all images finished*/
               let payloads: [String] = payloads.compactMap { $0 }
               _ = payloads
               Swift.print("Reading many HCCQR completed: \(abs(startTime.timeIntervalSinceNow))")
            }
         }
         images.enumerated().forEach { arg in
            DispatchQueue.global(qos: .userInitiated).async {
               func onComplete(payload: String?) {
                  DispatchQueue.main.async {
                     readHCCQRComplete(i: arg .offset, payload: payload)
                  }
               }
               //               HCCQRStringUtil.string(uiImage: arg.element, onComplete: onComplete)//
            }
         }
      }
      creatingManyHCCQRImages(onComplete: onImageCreationComplete)
   }
}
/**
 * Write
 */
extension BulkHCCQRTest {
   /**
    * Tests the speed of creating hccqr images
    */
   private static func creatingManyHCCQRImages(onComplete:@escaping (_ images: [Image]) -> Void) { // <- add typealais
      let (qrVersion, qrMode, ecLevel): (Int, QRMode, ECLevel) = (10, .byte, .l)/*Config*/
      let randomData: [Data] = (0..<10).compactMap { _ in/*Num of items to load*/
         guard let randomString: String = try? HCCQRStringData.randomString(config: (qrVersion, qrMode, ecLevel)) else { Swift.print("unable to create random string"); return nil }
         guard let data = randomString.data(using: .utf8) else { Swift.print("err data"); return nil }
         return data
      }
      var images: [Image?] = [Image?](repeating: nil, count: randomData.count)
      let startTime: Date = .init()
      func createHCCQRComplete(i: Int, hccqrImage: Image?) {
         guard let hccqrImage = hccqrImage else { fatalError("unable to create hccqr image") }
         images[i] = hccqrImage
         if images.first(where: { $0 == nil }) == nil {/* make sure all images finish */
            DispatchQueue.main.async {
               let images: [Image] = images.compactMap { $0 }
               Swift.print("Creating many HCCQR images completed: \(abs(startTime.timeIntervalSinceNow))")
               onComplete(images)
               // add the bellow when u add ImageView to repo
               //               let imgView: UIImageView = .init(image: images[0])
               //               self.view.addSubview(imgView)
            }
         }
      }
      // do stuff on bg thread
      randomData.enumerated().forEach { arg in
         DispatchQueue.global(qos: .userInitiated).async {
            HCCQRWriter.image(data: arg.element, multipliers: (moduleScale: 6, screenScale: 1), qrConfig: (qrVersion, ecLevel)) { result in createHCCQRComplete(i: arg.offset, hccqrImage: try? result.get()) }//
         }
      }
   }
}
