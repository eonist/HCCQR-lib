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
      let demoView = GridTestView(frame: GridTestView.frame)
      view.addSubview(demoView)
      guard let snapShot: UIImage = demoView.snapShot else { fatalError("err") }
//      let uiImageView: UIImageView = .init(image: snapShot)
//      uiImageView.frame.origin = .init(x: 0, y: GridTestView.frame.height)
//      self.view.addSubview(uiImageView)
      guard let rgbaRep: RGBARep = try? .rgbaRep(image: snapShot) else { fatalError("err") }
      guard let img: Image = try? RGBARepParser.image(rgbaImage: rgbaRep, scale: 2) else { fatalError("err") }
      let uiImageView: UIImageView = .init(image: img)
      uiImageView.frame.origin = .init(x: 0, y: GridTestView.frame.height)
      self.view.addSubview(uiImageView)
      Splitter.split(rgbaImage: rgbaRep) { (result: Splitter.Payload) in // Start the splitting process
         guard let payload: Splitter.CIIMGPair = result.value() else { fatalError("err") }
         let img: UIImage = .init(ciImage: payload.qrImg2, scale: 2, orientation: .up)
         let uiImageView: UIImageView = .init(image: img)
         uiImageView.frame.origin = .init(x: 0, y: GridTestView.frame.height * 2)
         self.view.addSubview(uiImageView)
      }
   }
}
