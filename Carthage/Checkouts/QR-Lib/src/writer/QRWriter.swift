import Foundation
/**
 * - Description: Data -> Image
 */
final public class QRWriter {
   /**
    * Data -> qrImage
    * - Important: ⚠️️⚠️️⚠️️ Make sure data.count is the same as the QRVersion allows, or else it will be hard to pull the data out again. With the current data extraction methods anyways
    */
   public static func image(data:Data, size:CGSize?, ecLevel:ECLevel = .l) throws -> Image {
      guard let ciImage:CIImage = try? QRWriter.ciImage(data: data, size: size, ecLevel:ecLevel) else { throw ("⚠️️ QRLib.QRUtil.qrImage() - Failed to create ciImage ecLevel:\(ecLevel.rawValue) data.count:\(data.count) size:\(String(describing: size)) ⚠️️") }
      let image:Image = ImageUtil.image(ciImage: ciImage)
      return image
   }
}
/**
 * Helpers
 */
extension QRWriter{
   /**
    * Data -> CIImage
    */
   public static func ciImage(data:Data, size:CGSize?, ecLevel:ECLevel) throws -> CIImage {
      guard let filter:CIFilter = CIFilter(name: "CIQRCodeGenerator") else {throw ("QRLib.QRUtil.ciImage() - Unable to create filter")  }
      filter.setValue(data, forKey: "inputMessage")
      filter.setValue(ecLevel.rawValue, forKey: "inputCorrectionLevel")
      guard let outputImage:CIImage = filter.outputImage else { throw ("QRLib.QRUtil.ciImage() - Unable to make CIImage for ecLevel:\(ecLevel.rawValue) str.count:\(data.count) size:\(String(describing: size))")  }
      outputImage.autoAdjustmentFilters()
      if let size = size {
         let scale:CGPoint = .init(x:size.width / outputImage.extent.width,y:size.height / outputImage.extent.height)
         let transformedImage:CIImage = outputImage.transformed(by: CGAffineTransform(scaleX: scale.x, y: scale.y))
         return transformedImage
      }else{
         return outputImage
      }
   }
}
