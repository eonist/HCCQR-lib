import UIKit
import QR_lib
import QuartzCore
import CoreGraphics
import CoreImage

extension ViewController {
   /**
    * Grid test
    */
   func testGrid() {
      let demoView = FakeHCCQRView(frame: FakeHCCQRView.frame)
      view.addSubview(demoView)
      guard let snapShot: UIImage = demoView.snapShot else { fatalError("err") }
      let uiImageView: UIImageView = .init(image: snapShot)
      uiImageView.frame.origin = .init(x: 0, y: FakeHCCQRView.frame.height)
      self.view.addSubview(uiImageView)
   }
}
