import Foundation
#if os(iOS)
import QRLibIOS
#elseif os(macOS)
import QRLibMac
#endif

/**
 * String -> Image
 */
public class HCCQRImageUtil{
   /**
    * Returns an HCCQR UIImage for a string
    * - Note: For example see repo readme
    * - IMPORTANT: ⚠️️ the caller must make sure the qrVersion can hold the amount of chars in string
    * - Parameter qrConfig: we supply version because it's more optimized than calculating moduleCount on the basis of data.count
    * - Parameter scale: This is the multiplier. ModuleCount equals 1 pixel. ModuleCount for QRVersion 10 is 57 not counting 2 for margins. So (57+2)*6 = 354, if you want 2xretina its 354 * 2 = 708
    * - TODO: ⚠️️ rename to image
    * - Note: use `Swift.print(hccqrImage?.hasOnlyColorMap(colorMap: [.red,.green,.blue,.white]))`//ensure that img only has valid colors, akak no bluring
    * ## Example:
    * let (qrVersion,qrMode,ecLevel):(Int,QRMode,ECLevel) = (10,.byte,.l)//settings
    * guard let randomString:String = HCCQRStringData.randomString(qrVersion: qrVersion, qrMode: qrMode, ecLevel:ecLevel) else {Swift.print("unable to create random string");return }
    * guard let data = randomString.data(using: .utf8) else {Swift.print("err data");return }
    * HCCQRImageUtil.getHCCQRImage(data:data,moduleMultiplier:6,scale: 2,qrConfig:(qrVersion,ecLevel), onComplete: { img in Swift.print("img.size:  \(img?.size)")})//
    */
   public static func getHCCQRImage(data:Data, moduleMultiplier:Int, scale:Int, qrConfig:QRConfig = (10,.l), onComplete: @escaping OnHCCQRImageComplete){
      let dataArr:[Data] = data.split(index: data.count/2)/*Split the data in two*/
      var qrImgs:[Image?] = [Image?](repeating: nil, count: dataArr.count)/*Pre-filled array for the images*/
//      let startTime:Date = Date()
      func onCreateQrImgComplete(i:Int,qrImg:Image?){
         guard let qrImg:Image = qrImg else { /*Swift.print();*/ onComplete(nil,"onCreateQrImgComplete() - ⚠️️ qrImg err ⚠️️ ");return}
         qrImgs[i] = qrImg/*it matters which order the qrImages came in when you stitch them back together*/
         if qrImgs.first(where: {$0 == nil}) == nil {/*makes sure all images finished*/
//            Swift.print("onCreateQrImgComplete: \(abs(startTime.timeIntervalSinceNow))")
            let qrImages:[Image] = qrImgs.compactMap{$0}
            guard let hccqrImage:Image = try? Colorize.colorize(images: qrImages, colorMap: Colorize.colorMap, moduleMultiplier:moduleMultiplier,scale:scale/*blandColorMap*/) else {/*Swift.print("");*/onComplete(nil,"getHCCQRImage - Unable to create colorized image");return}
            onComplete(hccqrImage,nil)
         }
      }
      let moduleCount:Int = QRModuleUtil.moduleCount(version: qrConfig.qrVersion)
      let length:CGFloat = CGFloat(moduleCount + 2) /*the 2 extra are margins*/
      dataArr.enumerated().forEach { (_ offset:Int,_ element:Data) in
         DispatchQueue.global(qos:.userInitiated).async {
            let qrImg:Image? = QRImageUtil.qrImage(data: element, size: .init(width:length,height:length), ecLevel: qrConfig.ecLevel)
            DispatchQueue.main.async{
               onCreateQrImgComplete(i:offset, qrImg: qrImg)
            }
         }
      }
   }
}
/**
 * Convenience
 */
extension HCCQRImageUtil{
   /**
    * For string
    * TODO: ⚠️️ rename to image
    */
   public static func getHCCQRImage(string str:String, moduleMultiplier:Int, scale:Int, qrConfig:QRConfig = (10,.l), onComplete: @escaping OnHCCQRImageComplete)  {
      guard let data:Data = str.data(using: .utf8) else { /*Swift.print(""); */onComplete(nil,"getHCCQRImage() - ⚠️️ data err ⚠️️ ");return}
      getHCCQRImage(data: data, moduleMultiplier:moduleMultiplier,scale: scale,qrConfig:qrConfig, onComplete: onComplete)
   }
}
/**
 * Type
 */
extension HCCQRImageUtil{
   public typealias QRConfig = (qrVersion:Int, ecLevel:ECLevel)
}
/**
 * Useful when you setup the callbacks in apps (Thats why they are in public scope)
 */
public typealias OnHCCQRImageComplete = (_ hccqrImage:Image?, _ error:Error?) -> Void
public typealias OnHCCQRDataComplete = (_ payload:Data?) -> Void
