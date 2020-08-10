import UIKit
import QR_lib
import QuartzCore
import CoreGraphics
import CoreImage
/**
 * Split + Composition test
 */
extension ViewController {
   /**
    * Row test
    * - Fixme: ⚠️️ A bug with split method, some sizes doesn't work etc
    * - Caution: ⚠️️ this has a bug in that the snapshot creates retina image, and this code doesn't support that yet
    * - Note: (creates a bunch of squares in B&W and then tries to make hccqr like image)
    */
   func testSplitting() {
      // let colorGridView = FakeHCCQRView(frame: .init(origin: .zero, size: .init(width: (100 * 2) - 0, height: (100 * 2) - 0)))
      // view.addSubview(colorGridView)
      let colorGridView = SplitTestView()
      view.addSubview(colorGridView)
      guard let snapShot: UIImage = colorGridView.snapShot() else { fatalError("err") }
      guard let rgbRep: RGBRep = try? RGBRep.imageRep(image: snapShot) else { fatalError("err") }
      let qrImgs: [CIImage] = Splitter.split(rgbRep: rgbRep, scheme: CType.c4.cs, parallel: true)
      rgbRep.deallocate() // we have no more use for the rgbRep
      let img: UIImage = .init(ciImage: qrImgs[0], scale: 2, orientation: .up)
      let uiImageView: UIImageView = .init(image: img)
      uiImageView.frame.origin = .init(x: 0, y: SplitTestView.height)
      self.view.addSubview(uiImageView)
   }
}
