import QR_lib
import Foundation
#if os(iOS)
import UIKit

class RGBAImageTest {}

extension RGBAImageTest {
   /**
    * Buffer test
    * - Fixme: ⚠️️ figure out how to create scale: 1 img easy, maybe the context draw stuff needs retina support, check scaling in hccqr code etc
    * 1. Creates a red image
    * 2. Renders the red-image into RGBAImage
    * 3. Adds the image to a imagecontainer and presents it in the view
    * 4. Asserts if the new image is the same as the original image
    */
   func bufferTest() {
      let image = UIImage.image(sizeDEPRECATED: .init(width: 100, height: 100), color: .red)!
      guard let rgbaImage: RGBAImage = try? CVImageBufferUtil.rgbaImage(image: image) else { Swift.print("err rgbImage"); return }
      guard let img: UIImage = try? RGBAImageUtil.image(rgbaImage: rgbaImage, scale: 1) else { Swift.print("err img"); return }
//      let imageView: UIImageView = .init(image: img)
//      view.addSubview(imageView)
      let isEqual: Bool = image.isEqualToImage(image: image)
      Swift.print("isEqual:  \(isEqual)")
   }
}
/**
 * DEPRECATED
 */
extension RGBAImageTest {
   /**
    * CIIMage -> RGBAImage -> CIImage
    * - Fixme: ⚠️️ Hock this test up to the unit-test
    */
   func test() {
      Swift.print("⚠️️ DEPRECATED ⚠️️")
      guard let image = UIImage.image(sizeDEPRECATED: .init(width: 100, height: 100), color: .blue) else { Swift.print("uiImage err"); return }
      Swift.print("image.scale:  \(image.scale)")
      Swift.print("image.size:  \(image.sizeDEPRECATED)")
      // create RGBAImage
      guard let ciImg = image.ciImage() else { Swift.print("err ciImg"); return }
      _ = ciImg
      //      guard let rgbaImage = try? RGBAImage.rgbaImg(ciImg: ciImg) else { Swift.print("rbgaImg err"); return }
      // create CIIMage
      // guard let ciImage: CIImage = try? RGBAImageUtil.ciImg2(rgbaImage: rgbaImage) else { Swift.print("ciimg err"); return }
      //      guard let ciImage: CIImage = try? RGBAImageUtil.ciImg2(rgbaImage: rgbaImage, useGrayscale: false/*, opaque: false*/ ) else { Swift.print("ciimg err"); return }
      // assert that CIMage match first CIImage
      //      Swift.print("ciImage.extent.width:  \(ciImage.extent.width)")
      //      Swift.print("ciImage.extent.height:  \(ciImage.extent.height)")
      //      Swift.print("ciImage.colorSpace:  \(String(describing: ciImage.colorSpace))")
      //      let img: UIImage = .init(ciImage: ciImage)
      //      Swift.print("img.size:  \(img.size)")
      //      Swift.print("img.scale:  \(img.scale)")
      // img
      //      Swift.print("\(image.isEqualToImage(image: img) ? "✅" : "🚫")") // Doesn't work because colorspace is changed
      //      let imageView: UIImageView = .init(image: img)
      //      self.view.addSubview(imageView)
   }
}
#endif
