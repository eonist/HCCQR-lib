import Foundation
import QR_lib
/**
 * String -> Image
 */
public class HCCQRWriter {
   /**
    * Returns an HCCQR UIImage for a string
    * - Note: For more in-depth example see repo readme
    * - Important: ⚠️️ the caller must make sure the qrVersion can hold the amount of chars in string
    * - Note: use `Swift.print(hccqrImage?.hasOnlyColorMap(colorMap: [.red, .green, .blue, .white]))`//ensure that img only has valid colors, akak no bluring
    * ## Example:
    * let (qrVersion, qrMode, ecLevel): HCCQRConfig = (10, .byte, .l) // settings
    * guard let randomString: String = HCCQRStringData.randomString(qrVersion: qrVersion, qrMode: qrMode, ecLevel:ecLevel) else { Swift.print("unable to create random string");return }
    * guard let data = randomString.data(using: .utf8) else { Swift.print("err data");return }
    * HCCQRImageUtil.getHCCQRImage(data:data,moduleMultiplier: 6, scale: 2, qrConfig: (qrVersion, ecLevel), onComplete: { img in Swift.print("img.size:  \(img?.size)") })//
    * - Parameters:
    *   - data: The data to be embedded into the HCCQR-image
    *   - moduleMultiplier: ModuleCount equals 1 pixel. ModuleMultiplier scales this
    *   - qrConfig: we supply version because it's more optimized than calculating moduleCount on the basis of data.count
    *   - scale: for retina you need 2x scale etc
    */
   public static func image(data: Data, moduleMultiplier: Int, scale: Int, qrConfig: QRConfig = (10, .l), onComplete: @escaping OnHCCQRImageComplete) {
      let dataArr: [Data] = data.split(index: data.count / 2) // Split the data in two
      var qrImgs: [Image?] = [Image?](repeating: nil, count: dataArr.count) // Pre-filled array for the images
      // 🏀
         // move the bellow method into a private static method
      func onCreateQrImgComplete(i: Int, qrImg: Image?) {
         guard let qrImg: Image = qrImg else { onComplete(nil, "HCCQRWriter.image() - onCreateQrImgComplete() - ⚠️️ qrImg err ⚠️️ "); return }
         qrImgs[i] = qrImg // it matters which order the qrImages came in when you stitch them back together
         if qrImgs.first(where: { $0 == nil }) == nil { // makes sure all images finished
            let qrImages: [Image] = qrImgs.compactMap { $0 }
            guard let hccqrImage: Image = try? Colorizer.colorize(images: qrImages, colorMap: Colorizer.colorMap, moduleMultiplier: moduleMultiplier, scale: scale/*blandColorMap*/) else { onComplete(nil, "getHCCQRImage - Unable to create colorized image"); return }/*Swift.print("");*/ 
            onComplete(hccqrImage, nil)
         }
      }
      dataArr.enumerated().forEach { (_ offset: Int, _ element: Data) in
         DispatchQueue.global(qos: .userInitiated).async {
            let qrImg: Image? = try? QRWriter.image(data: element, ecLevel: qrConfig.ecLevel)
            DispatchQueue.main.async {
               onCreateQrImgComplete(i: offset, qrImg: qrImg)
            }
         }
      }
   }
}
