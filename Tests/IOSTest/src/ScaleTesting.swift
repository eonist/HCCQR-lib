import QR_lib
import QuartzCore
import CoreGraphics
import CoreImage
@testable import HCCQR_lib

final class ScaleTesting {}
extension ScaleTesting {
   /**
    * - Fixme: ⚠️️ split this up a bit maybe?
    */
   static func testScalingRGBAImage() {
//      let randomString: String = QRStringData.randomString(max: stringCount * 2, qrMode: .byte)
      let config: QRConfig = (version: .v4, mode: .byte, ecLevel: .l)
      _ = { // Test HCCQR scaling
         let randomString: String = HCCQRStringData.randomString(config: config)// else { Swift.print("Unable to crate ran string"); return }
         guard let data: Data = randomString.data(using: .utf8) else { Swift.print("err"); return }
         let dataArr: [Data] = data.split(index: data.count / 2)/*Split the data in two*/
         guard let firstItem: Data = dataArr.last else { Swift.print("err data"); return }
         Swift.print("firstItem.count:  \(firstItem.count)")
         guard let version: Int = QRVersion.version(dataCount: firstItem.count, qrMode: .byte, ecLevel: .l) else { Swift.print("err version"); return }
         Swift.print("version:  \(version)")
         guard let moduleCount: Int = QRModuleUtil.moduleCount(dataCount: firstItem.count, ecLevel: .l) else { Swift.print("err"); return }
         Swift.print("moduleCount:  \(moduleCount)")
         let moduleMultiplier: CGFloat = 8
         let side: CGFloat = .init(moduleCount + 2) * moduleMultiplier /*+2 because margin*/
         _ = side
      }()
      _ = { // Test QR scaling
         let stringCount: Int = QRConfigUtil.dataCount(config: config)
         let randomStr: String = QRStringData.randomString(max: stringCount, qrMode: .byte)
         //      Swift.print("randomStr.count:  \(randomStr.count)")
         guard let dataItem: Data = randomStr.data(using: .utf8, allowLossyConversion: false) else { Swift.print("err"); return }
         Swift.print("dataItem:  \(dataItem)")
         guard let qrImage: Image = try? QRWriter.image(data: dataItem, ecLevel: .l) else { Swift.print("unable to create UIImage");return }
         //add qr to rgba
         guard let rgbaImage: RGBAImage = try? .rgbaImage(image: qrImage) else { Swift.print("unable to get rgbaimage from img"); return }
         //scale rgba
         let scaledRGBAImage: RGBAImage = RGBAImageScaler.scale(rgbaImage: rgbaImage, multiplier: 6)
         //dispay image from rgba
         guard let img: Image = try? RGBAImageUtil.image(rgbaImage: scaledRGBAImage, scale: 1) else { Swift.print("unable to get img from rgbaimage"); return }
         // 🏀 add ImageView to this repo and add the two lines bellow
         //      let uiImageView: ImageView = .init(image: img)
         //      view.addSubview(uiImageView)
         guard let ciImg: CIImage = img.ciImage ?? img.ciImage() else { Swift.print("err ciimg"); return }
         let symbolVersion: Int? = try? ciImg.symbolVersion()
         Swift.print("symbolVersion:  \(String(describing: symbolVersion))")
         let ecLevel = try? ciImg.ecLevel()
         Swift.print("ecLevel:  \(ecLevel == CIQRCodeDescriptor.ErrorCorrectionLevel.levelL)")
      }()
   }
   /**
    *
    */
   static func testScalingCIIMage() {
      //      Swift.print("resultImage.ciImage():  \(resultImage.ciImage())")
      //      Swift.print("resultImage.cgImage:  \(resultImage.cgImage)")
      //      guard let outputImage:CIImage = resultImage.ciImage() else {Swift.print("Unable to create CIImage");return nil}
      //      let scale:CGPoint = {
      //         let x = length*6 / outputImage.extent.size.width
      //         let y = length*6 / outputImage.extent.size.height
      //         return .init(x:x,y:y)
      //      }()
      //      //      Swift.print("scale:  \(scale)")
      //      let transformedImage:CIImage = outputImage.transformed(by: CGAffineTransform(scaleX: scale.x, y: scale.y))
      //      let uiImage:UIImage = .init(ciImage: transformedImage)
      //      return uiImage
      //      return UIImage.init(ciImage: outputImage, scale: 0.06, orientation: .down)
   }
}
