import QR_lib
import QuartzCore
import CoreGraphics
import CoreImage

final class ColorizerTest {}

extension ColorizerTest {
   /**
    * Tests colorizer method
    * - Fixme: ⚠️️ needs some refactoring and cleaning
    */
   static func testColorizer() {
      guard let img1 = createQRImg() else { Swift.print("err"); return }
      Swift.print("view1.image?.scale:  \(img1.scale)")
      Swift.print("view1.image?.size:  \(img1.size)")
      guard let img2 = createQRImg() else { Swift.print("err"); return }
      _ = {
         let imgs: [Image] = [img1, img2].compactMap { $0 }
         guard let resultImage: Image = try? Colorizer.colorize(images: imgs, colorMap: Colorizer.colorMap, multipliers: (moduleScale: 1, screenScale: 2)) else { Swift.print("unable to create colorized image"); return }
         Swift.print("resultView.scale:  \(String(describing: resultImage.scale))")
         Swift.print("resultView.image?.size:  \(String(describing: resultImage.size))")
         Swift.print("hasOnly these colors: \(ColorMapAsserter.hasOnlyColorMap(uiImage: resultImage, colorMap: [.red, .green, .blue, .white]))")
      }()
   }
}
extension ColorizerTest {
   /**
    * Returns qr img
    */
   private static func createQRImg() -> Image? {
      let string: String = QRStringData.randomString(max: 16, qrMode: .byte)
      guard let moduleCount: Int = QRModuleUtil.moduleCount(string: string, qrMode: .byte, ecLevel: .l) else { Swift.print("err"); return nil }
      //      Swift.print("moduleCount:  \(moduleCount)")
      //      let length: CGFloat = .init(moduleCount + 2) * 16 // 80 * 4
      //(str: string, size: .init(width: length, height: length), ecLevel: .l) else {Swift.print("unable to create UIImage");return nil}
      guard let stringCount: Int = QRVersion.maxChar(qrVersion: 4, qrMode: .byte, ecLevel: .l) else { Swift.print("⚠️️ Unable to get stringCount ⚠️️"); return nil }//533
      let randomStr: String = QRStringData.randomString(max: stringCount, qrMode: .byte)
      guard let dataItem: Data = randomStr.data(using: .utf8, allowLossyConversion: false) else { Swift.print("err"); return nil }
      guard let image: Image = try? QRWriter.image(data: dataItem, ecLevel: .l, moduleMultiplier: moduleCount) else { Swift.print("unable to create UIImage");return nil }
      //Swift.print("image.hasNoneBlackOrWhiteColor:  \(image.hasOnlyBlackAndWhiteColorMap)")
      return image
   }
}
