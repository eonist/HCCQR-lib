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
    * IMPORTANT: ⚠️️ the caller must make sure the qrVersion can hold the amount of chars in string
    * ## Examples:
    * let (qrVersion,qrMode,ecLevel):(Int,QRMode,ECLevel) = (10,.byte,.l)//settings
    * guard let stringCount:Int = QRVersion.maxChar(qrVersion:qrVersion,qrMode:qrMode,ecLevel: ecLevel) else {Swift.print("⚠️️ Unable to get stringCount ⚠️️");return}//533
    * let strCount:Int = stringCount * 2//542
    * let randomString = QRStringData.randomString(max: strCount, qrMode: .byte)
    * let hccqrImage:UIImage? = getHCCQRImage(string:randomString,qrVersion:qrVersion,qrMode:qrMode,ecLevel:ecLevel)
    * let imgView = UIImageView(image(hccqrImage))
    * view.addSubview(imgView)
    * Swift.print(hccqrImage?.hasOnlyColorMap(colorMap: [.red,.green,.blue,.white]))//ensure that img only has valid colors, akak no bluring
    * - Parameter qrConfig: we supply version because it's more optimized than calculating moduleCount on the basis of data.count
    */
   public static func getHCCQRImage(data:Data, scale:Int, qrConfig:QRConfig = (10,.l), onComplete: @escaping OnHCCQRImageComplete){
      let dataArr:[Data] = data.split(index: data.count/2)
      var qrImgs:[Image?] = [Image?](repeating: nil, count: dataArr.count)/*Pre-filled array for the images*/
      func onCreateQrImgComplete(i:Int,qrImg:Image?){
         guard let qrImg:Image = qrImg else { Swift.print("onCreateQrImgComplete() - ⚠️️ qrImg err ⚠️️ "); onComplete(nil);return}
         qrImgs[i] = qrImg//it matters which order the qrImages came in when you stitch them back together
         if qrImgs.first(where: {$0 == nil}) == nil {/*makes sure all images finished*/
            let qrImages:[Image] = qrImgs.compactMap{$0}
            guard let hccqrImage:Image = Colorize.colorize(images: qrImages, colorMap: Colorize.colorMap, scale:scale/*blandColorMap*/) else {Swift.print("Unable to create colorized image");onComplete(nil);return}
            onComplete( hccqrImage )
         }
      }
      let moduleCount:Int = QRModuleUtil.moduleCount(version: qrConfig.qrVersion)
      let length:CGFloat = CGFloat(moduleCount + 2) /*the 2 extra are margins*/
      dataArr.enumerated().forEach { arg in
         DispatchQueue.global(qos:.background).async {
            let qrImg:Image? = QRImageUtil.qrImage(data: arg.element, size: .init(width:length,height:length), ecLevel: qrConfig.ecLevel)
            DispatchQueue.main.async{
               onCreateQrImgComplete(i:arg.offset,qrImg: qrImg)
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
    */
   public static func getHCCQRImage(string str:String, scale:Int, qrConfig:QRConfig = (10,.l), onComplete: @escaping OnHCCQRImageComplete)  {
      guard let data:Data = str.data(using: .utf8) else { Swift.print("getHCCQRImage() - ⚠️️ data err ⚠️️ "); onComplete(nil);return}
      getHCCQRImage(data: data, scale: scale,qrConfig:qrConfig, onComplete: onComplete)
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
public typealias OnHCCQRImageComplete = (_ hccqrImage:Image?) -> Void
public typealias OnHCCQRDataComplete = (_ payload:Data?) -> Void
