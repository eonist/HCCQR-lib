import Foundation
@testable import HCCQR_lib
import QR_lib
import ResourceHelper
/**
 * - Fixme: ⚠️️ try bigger numbers
 */
extension BulkPhotoTest {
   static var writeTime: Date = .init()
   static var readTime: Date = .init()
   /**
    * writeMany
    * - Note: Convert photo's into RGBARep's
    */
   static func writeMany(onComplete: OnWriteManyComplete) {
//      Swift.print("writeMany()")
      let path: String = ResourceHelper.projectRootURL(projectRef: #file, fileName: "temp.bundle/HCCQR2.png").path
//      Swift.print("path:  \(path)")
      //let path: String = Bundle.main.resourcePath!+"/temp.bundle/HCCQR10.png" // HCCQR12.png,HCCQR13.jpg
      let rgbaImages: [RGBARep] = (0..<10).compactMap { _ in
         guard let image = Image(contentsOfFile: path) else { Swift.print("Err creating img at path: \(path)"); return nil }
//         Swift.print("image.size:  \(image.size)")
         guard let rgbaImage: RGBARep = try? BufferUtil.rgbaRep(image: image) else { Swift.print("err getting rgbImage"); return nil }
         return rgbaImage
      }
      onComplete(rgbaImages)
   }
   /**
    * readMany
    */
   static func readMany(rgbaImages: [RGBARep], onComplete: @escaping OnReadManyComplete) {
      Swift.print("readMany()")
      var dataArray: [Data?] = .init(repeating: nil, count: rgbaImages.count) // Stores the results in this array
      rgbaImages.enumerated().forEach { arg in
         //DispatchQueue.main.async {
         Reader.dataAndQR(rgbaRep: arg.element) { result in  // Process the hccqrImg
            onReadComplete(result: result, i: arg.offset, dataArray: &dataArray, onComplete: onComplete)
         }
         //}
      }
   }
}
