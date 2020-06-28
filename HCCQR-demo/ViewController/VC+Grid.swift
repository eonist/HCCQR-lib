import UIKit
import QR_lib
import QuartzCore
import CoreGraphics
import CoreImage

extension ViewController {
   /**
    * Grid test
    * - Note: the channels becomes bright towards white
    * - Note: all other parts become black
    */
   func testGrid() {
      let demoView = GridTestView(frame: GridTestView.frame)
      view.addSubview(demoView)
      guard let snapShot: UIImage = demoView.snapShot() else { fatalError("err") }
      Swift.print("snapShot.scale:  \(snapShot.scale)")
//      let uiImageView: UIImageView = .init(image: snapShot)
//      uiImageView.frame.origin = .init(x: 0, y: GridTestView.frame.height)
//      self.view.addSubview(uiImageView)
      guard let rgbaRep: RGBARep = try? .rgbaRep(image: snapShot) else { fatalError("err") }
//      guard let img: Image = try? RGBARepParser.image(rgbaImage: rgbaRep, scale: 2) else { fatalError("err") }
//      let uiImageView: UIImageView = .init(image: img)
//      uiImageView.frame.origin = .init(x: 0, y: GridTestView.frame.height)
//      self.view.addSubview(uiImageView)
      Splitter.split(rgbaImage: rgbaRep) { (result: Splitter.SplitResult) in // Start the splitting process
         guard let payload: Splitter.Payload = result.value() else { fatalError("err") }
         let redChannel: GrayscaleRep = payload.rgbChannels.r
//         redChannel.pixels.enumerated().forEach {
//            if $0.element > 0 {
////               Swift.print("$0.element:  \($0.element)")
//            }
//         }
         let redChannelImg: CIImage = GrayscaleRepParser.ciImage(grayscaleImage: redChannel)
         let img = UIImage(ciImage: redChannelImg, scale: 2, orientation: .up)
         let imgView: UIImageView = .init(image: img)
         self.view.addSubview(imgView)
//         let img: UIImage = .init(ciImage: redChannelImg, scale: 1, orientation: .up)
//         let uiImageView: UIImageView = .init(image: img)
         imgView.frame.origin = .init(x: 0, y: GridTestView.frame.height * 1)
//         self.view.addSubview(uiImageView)
      }
   }
}
