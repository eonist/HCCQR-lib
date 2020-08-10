import QR_lib
import QuartzCore
import CoreGraphics
import CoreImage
@testable import HCCQR_lib

final class ScaleTesting {}
extension ScaleTesting {
   /**
    * Scales a QR image
    * 1. Creates a QR-image
    * 2. Adds the QR to a RGBImage
    * 3. Scales the RGBImage
    * 4. Asserts that the QR-Image is intact
    * - Fixme: ⚠️️ split this up a bit maybe? Yes, make many methods and use try try try try in the main test method
    * - Fixme: ⚠️️  add ImageView to this repo and add the two lines bellow
    */
   static func testScalingRGBARep() -> Int? {
//      Swift.print("⚠️️ broken")
      let config: QRConfig = .init(.v4, .byte, .l)
      let image: Image? = { // Test QR scaling
         let stringCount: Int = config.maxChar
         let randomStr: String = RandomData.randomString(count: stringCount, qrMode: .byte)
         guard let dataItem: Data = randomStr.data(using: .utf8, allowLossyConversion: false) else { Swift.print("err"); return nil }
         guard let qrImage: Image = try? QRWriter.image(data: dataItem, ecLevel: .l) else { Swift.print("unable to create UIImage");return nil }
         guard let rgbRep: RGBRep = try? RGBRep.imageRep(image: qrImage) else { Swift.print("unable to get rgbaimage from img"); return nil }
         let scaledRGBARep: RGBRep = rgbRep// ⚠️️ broken here RGBARepModifier.scale(pixels: rgbaRep.pixels, size: rgbaRep.size, scale: .init(6, 1))
         guard let img: Image = try? scaledRGBARep.image(scale: 1) else { Swift.print("unable to get img from rgbaimage"); return nil }
         return img
      }()
      guard let ciImg: CIImage = image?.ciImage() else { Swift.print("err ciimg"); return nil }
      let symbolVersion: Int? = try? ciImg.symbolVersion()
      return symbolVersion
   }
}
