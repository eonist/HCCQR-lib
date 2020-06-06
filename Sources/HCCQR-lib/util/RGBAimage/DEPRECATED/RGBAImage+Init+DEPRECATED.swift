import Foundation
import CoreImage
/**
 * DEPREDCATED
 */
extension RGBAImage {
   /**
    * CIImage -> RGBAImage
    * - Caution: ⚠️️ This doesn't work if the ciImage is created a special way, it works if input ciimage is created the old way
    */
   private static func rgbaImage(ciImage: CIImage) throws -> RGBAImage {
      //      Swift.print("ciImage.extent.size:  \(ciImage.extent.size)")
      guard let cgImg: CGImage = ciImage.cgImage ?? ciImage.cgImage() else { throw NSError(domain: "rgbaImage - Unable to get cgImage", code: 0) }
      //      Swift.print("cgImg:  \(cgImg.width)")
      return try rgbaImage(cgImage: cgImg)
   }
}
extension CIImage {
   /**
    * CIImage -> CGImage
    */
   private func cgImage() -> CGImage? {
      // guard let ciImage: CIImage = self.ciImage else { Swift.print("cgImage() - unable to get ciImage"); return nil }
      // let context: CIContext = .init(options: nil)
      return Image.ciContext.createCGImage(self, from: self.extent)
   }
}
