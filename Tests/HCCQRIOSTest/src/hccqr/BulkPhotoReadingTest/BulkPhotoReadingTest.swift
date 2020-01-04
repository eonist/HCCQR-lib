import Foundation
@testable import HCCQR_lib
import QR_lib

class BulkPhotoReadingTest {}
extension BulkPhotoReadingTest {
   typealias OnComplete = (Bool) -> Void
   typealias OnWriteManyComplete = (_ rgbaImages: [RGBAImage]) -> Void
   typealias OnReadManyComplete = () -> Void
}
// split it up
// try bigger numbers
extension BulkPhotoReadingTest {
   static var writeTime: Date = .init()
   static var readTime: Date = .init()
   // timer
   /**
    * Initiate test
    */
   static func test(onComplete: @escaping OnComplete) {
      writeTime = .init()
      writeMany { rgbaImages in
         Swift.print("rgbaImages.count:  \(rgbaImages.count)")
         Swift.print("writeTime \(abs(writeTime.timeIntervalSinceNow))")
         readTime = .init()
         readMany(rgbaImages: rgbaImages) {
            Swift.print("readTime \(abs(readTime.timeIntervalSinceNow))")
            onComplete(true)
         }
      }
   }
   static func writeMany(onComplete: OnWriteManyComplete) {
      Swift.print("writeMany()")
      let path: String = ResourceHelper.projectRootURL(fileName: "temp.bundle/HCCQR10.png").path
//      let path: String = Bundle.main.resourcePath!+"/temp.bundle/HCCQR10.png" // HCCQR12.png,HCCQR13.jpg
      let rgbaImages: [RGBAImage] = (0..<10).compactMap { _ in
         guard let image = Image(contentsOfFile: path) else { Swift.print("err getting img"); return nil }
         Swift.print("image.size:  \(image.size)")
         guard let rgbaImage: RGBAImage = try? CVImageBufferUtil.rgbaImage(image: image) else { Swift.print("err getting rgbImage"); return nil }
         return rgbaImage
      }
      onComplete(rgbaImages)
   }
   /**
    * readMany
    */
   static func readMany(rgbaImages: [RGBAImage], onComplete: @escaping OnReadManyComplete) {
      Swift.print("readMany()")
      var dataArray: [Data?] = .init(repeating: nil, count: rgbaImages.count)
      rgbaImages.enumerated().forEach { arg in
//         DispatchQueue.main.async {
            HCCQRReader.dataAndImages(rgbaImage: arg.element) { result in  // Split the hccqrImg
               onReadComplete(result: result, i: arg.offset, dataArray: &dataArray, onComplete: onComplete)
            }
//         }
      }
   }
}
/**
 * Handler
 */
extension BulkPhotoReadingTest {
   /**
    * onReadComplete
    */
   static func onReadComplete(result: HCCQRReader.DataAndImagesResult, i: Int, dataArray: inout [Data?], onComplete: @escaping OnReadManyComplete) {
      guard  let data: Data = try? result.get().data else { Swift.print("unable to get data· \(result.errorStr)"); return }
      Swift.print("data.count: \(data.count)")
//      DispatchQueue.main.sync {
      dataArray[i] = data
      if dataArray.first(where: { $0 == nil }) == nil {
         Swift.print("Array has zero nils ✅")
         onComplete()
      } // else { Swift.print("Array has nils 🚫") }
      
         // Concurrently execute a task using the global concurrent queue. Also known as the background queue.
//      }
   }
}
//DispatchQueue.global().async {
//   /// Concurrently execute a task using the global concurrent queue. Also known as the background queue.
//}
