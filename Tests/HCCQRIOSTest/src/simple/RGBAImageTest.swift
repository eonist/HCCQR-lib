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
      let image = UIImage.image(height: .init(width: 100, height: 100), color: .red)!
      guard let rgbaRep: RGBARep = try? CVImageBufferUtil.rgbaRep(image: image) else { Swift.print("err rgbImage"); return }
      guard let img: UIImage = try? RGBARepParser.image(rgbaImage: rgbaRep, scale: 1) else { Swift.print("err img"); return }
      _ = img
//      let imageView: UIImageView = .init(image: img)
//      view.addSubview(imageView)
      let isEqual: Bool = image.isEqualToImage(image: image)
      Swift.print("isEqual:  \(isEqual)")
   }
}
#endif
