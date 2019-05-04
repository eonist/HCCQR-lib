import Foundation
#if os(iOS)
import QRLibIOS
#elseif os(macOS)
import QRLibMac
#endif
/**
 * String -> Image
 */
public class HCCQRWriter {
   /**
    * Returns an HCCQR UIImage for a string
    * - Note: For more in-depth example see repo readme
    * - IMPORTANT: ⚠️️ the caller must make sure the qrVersion can hold the amount of chars in string
    * - Parameter qrConfig: we supply version because it's more optimized than calculating moduleCount on the basis of data.count
    * - Parameter scale: This is the multiplier. ModuleCount equals 1 pixel. ModuleCount for QRVersion 10 is 57 not counting 2 for margins. So (57+2)*6 = 354, if you want 2xretina its 354 * 2 = 708
    * - Fixme: ⚠️️ rename to image
    * - Note: use `Swift.print(hccqrImage?.hasOnlyColorMap(colorMap: [.red,.green,.blue,.white]))`//ensure that img only has valid colors, akak no bluring
    * ## Example:
    * let (qrVersion,qrMode,ecLevel):(Int,QRMode,ECLevel) = (10,.byte,.l)//settings
    * guard let randomString:String = HCCQRStringData.randomString(qrVersion: qrVersion, qrMode: qrMode, ecLevel:ecLevel) else {Swift.print("unable to create random string");return }
    * guard let data = randomString.data(using: .utf8) else {Swift.print("err data");return }
    * HCCQRImageUtil.getHCCQRImage(data:data,moduleMultiplier:6, scale:2,qrConfig:(qrVersion,ecLevel), onComplete: { img in Swift.print("img.size:  \(img?.size)")})//
    * - Fixme: ⚠️️ we dont need qrConfig anymore, we can use ecLvel alone
    */
   public static func image(data:Data, moduleMultiplier:Int, scale:Int, qrConfig:QRConfig = (10,.l), onComplete: @escaping OnHCCQRImageComplete){
      let dataArr: [Data] = data.split(index: data.count / 2)/*Split the data in two*/
//      Swift.print("dataArr.first?.count:  \(dataArr.first?.count)")
      var qrImgs: [Image?] = [Image?](repeating: nil, count: dataArr.count)/*Pre-filled array for the images*/
      func onCreateQrImgComplete(i: Int, qrImg: Image?){
//         guard let ciImage = qrImg?.ciImage else {Swift.print("err ciImge");return}
//         guard let qrData:Data = try? QRReader.data(ciImage:ciImage ) else {Swift.print("ERR qrData");return}
//         Swift.print("qrData.count:  \(qrData.count)")
//         return
         guard let qrImg: Image = qrImg else { onComplete(nil,"HCCQRWriter.image() - onCreateQrImgComplete() - ⚠️️ qrImg err ⚠️️ ");return}
         qrImgs[i] = qrImg/*it matters which order the qrImages came in when you stitch them back together*/
         if qrImgs.first(where: {$0 == nil}) == nil {/*makes sure all images finished*/
            let qrImages: [Image] = qrImgs.compactMap{ $0 }
            guard let hccqrImage: Image = try? Colorizer.colorize(images: qrImages, colorMap: Colorizer.colorMap, moduleMultiplier: moduleMultiplier, scale: scale/*blandColorMap*/) else {/*Swift.print("");*/onComplete(nil,"getHCCQRImage - Unable to create colorized image");return}
            onComplete(hccqrImage, nil)
         }
      }
//      let moduleCount:Int = QRModuleUtil.moduleCount(version: qrConfig.qrVersion)
//      Swift.print("moduleCount:  \(moduleCount)")
//      let length:CGFloat = CGFloat(moduleCount + 2) /*the 2 extra are margins*/
      dataArr.enumerated().forEach { (_ offset: Int,_ element: Data) in
         DispatchQueue.global(qos:.userInitiated).async {
            let qrImg: Image? = try? QRWriter.image(data: element/*, size: .init(width:length,height:length),*/, ecLevel: qrConfig.ecLevel)
            DispatchQueue.main.async {
               onCreateQrImgComplete(i: offset, qrImg: qrImg)
            }
         }
      }
   }
}
