#if os(iOS)
import UIKit
@testable import HCCQR_lib

final class CIImageTest {
   /**
    * UIImage -> RGBRep -> CIImage
    * - Fixme: ⚠️️ fix the bellow test somehow, maybe?
    */
   static func testCIImage() -> Bool {
      guard let image = UIImage.image(size: .init(width: 100, height: 100), color: .green) else { Swift.print("uiImage err"); return false }
      Swift.print("image.scale:  \(image.scale)")
      Swift.print("image.size:  \(image.size)")
      // create RGBAImage
      guard let rgbRep = try? .init(image: image) else { Swift.print("rbgaImg err"); return false }
      // create CIIMage
      guard let ciImage: CIImage = try? rgbRep.ciImage(useGrayscale: false) else { Swift.print("ciimg err"); return false }
      // assert that CIMage match first CIImage
      Swift.print("ciImage.extent.width:  \(ciImage.extent.width)")
      Swift.print("ciImage.extent.height:  \(ciImage.extent.height)")
      Swift.print("ciImage.colorSpace:  \(String(describing: ciImage.colorSpace))")
      let img: UIImage = .init(ciImage: ciImage)
      Swift.print("img.size:  \(img.size)")
      Swift.print("img.scale:  \(img.scale)")
      // img
      let equalsImage: Bool = image.isEqualToImage(image: img)
      Swift.print("isEqualToImage: \(equalsImage ? "✅" : "🚫")")
      return equalsImage
   }
}
#endif
