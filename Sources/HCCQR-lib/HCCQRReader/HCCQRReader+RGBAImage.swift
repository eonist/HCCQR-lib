import Foundation
import QR_lib
import QuartzCore
import CoreImage

extension HCCQRReader {
   public typealias OnDataAndMetaComplete = (HCCQRReader.DataAndMetaResult) -> Void
   /**
    * ImageBuffer -> DataAndQuad
    */
   public static func dataAndMeta(imageBuffer: CVImageBuffer, onComplete: @escaping OnDataAndMetaComplete) {
      guard let rgbaImg: RGBAImage = try? CVImageBufferUtil.rgbaImage(imageBuffer: imageBuffer) else { onComplete(.failure("unable to get RGBAImage")); return }
      HCCQRReader.dataAndImages(rgbaImage: rgbaImg) { (result: HCCQRReader.DataAndImagesResult) in
         guard let dataAndImagesAndQuad: HCCQRReader.DataAndImages = try? result.get() else { onComplete(.failure("unable to get dataAndImages: \(result.errorStr)")); return }
         guard let data: Data = dataAndImagesAndQuad.data, let quad = dataAndImagesAndQuad.quad  else { onComplete(.failure("unable to get data or quad")); return }
         let size: CGSize = .init(width: CGFloat(rgbaImg.width), height: CGFloat(rgbaImg.height))
         let dataAndMeta: DataAndMeta = (data: data, quad: quad, imageSize: size)
         onComplete(.success(dataAndMeta))
      }
   }
   /**
    * Creates data for HCCQQR image
    * - Abstract: Since we get pixel data from the camera, this will be faster than converting to image first
    * - Fixme: ⚠️️ When the first QRImage Quad is found, the subsequent QR-Rects will be in the same quadrant, clip the subsequent images
    */
   static func dataAndImages(rgbaImage: RGBAImage, onComplete:@escaping DataAndImageCompleted) {
      Splitter.split(rgbaImage: rgbaImage) { result in // Start the splitting process
//         readTime += abs(HCCQRReader.splitTime.timeIntervalSinceNow)
//         Swift.print("👉 Splitting rgbaImage done: \(abs(HCCQRReader.splitTime.timeIntervalSinceNow))")
         onSplitComplete(result: result, onComplete: onComplete)
      }
   }
}
