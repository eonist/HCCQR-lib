import Foundation
import QR_lib
import QuartzCore
import CoreImage
/**
 * Adds support for CVImageBuffer
 */
extension HCCQRReader {
   /**
    * ImageBuffer -> DataAndQuad
    */
   public static func dataAndMeta(imageBuffer: CVImageBuffer, crop: BufferRect, onComplete: @escaping OnDataAndMetaComplete) {
      guard let rgbaImg: RGBAImage = try? CVImageBufferUtil.rgbaImage(imageBuffer: imageBuffer, crop: crop) else { onComplete(.failure("unable to get RGBAImage")); return }
      dataAndImages(rgbaImage: rgbaImg) { (result: HCCQRReader.DataAndImagesResult) in
         guard let dataAndImagesAndQuad: HCCQRReader.DataAndImages = try? result.get() else { onComplete(.failure("unable to get dataAndImages: \(result.errorStr)")); return }
         guard let data: Data = dataAndImagesAndQuad.data, let quad = dataAndImagesAndQuad.quad  else { onComplete(.failure("unable to get data or quad")); return }
         let size: CGSize = .init(width: CGFloat(rgbaImg.width), height: CGFloat(rgbaImg.height))
         let dataAndMeta: DataAndMeta = (data: data, quad: quad, imageSize: size)
         onComplete(.success(dataAndMeta))
      }
   }
}
