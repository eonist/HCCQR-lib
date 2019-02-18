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
    */
   public static func getHCCQRImage(data:Data, moduleMultiplier:Int, scale:Int, qrConfig:QRConfig = (10,.l), onComplete: @escaping OnHCCQRImageComplete){
      let dataArr:[Data] = data.split(index: data.count/2)/*Split the data in two*/
      var qrImgs:[Image?] = [Image?](repeating: nil, count: dataArr.count)/*Pre-filled array for the images*/
//      let startTime:Date = Date()
      func onCreateQrImgComplete(i:Int,qrImg:Image?){
         guard let qrImg:Image = qrImg else { Swift.print("onCreateQrImgComplete() - ⚠️️ qrImg err ⚠️️ "); onComplete(nil);return}
         qrImgs[i] = qrImg/*it matters which order the qrImages came in when you stitch them back together*/
         if qrImgs.first(where: {$0 == nil}) == nil {/*makes sure all images finished*/
//            Swift.print("onCreateQrImgComplete: \(abs(startTime.timeIntervalSinceNow))")
            let qrImages:[Image] = qrImgs.compactMap{$0}
            guard let hccqrImage:Image = Colorize.colorize(images: qrImages, colorMap: Colorize.colorMap, moduleMultiplier:moduleMultiplier,scale:scale/*blandColorMap*/) else {Swift.print("Unable to create colorized image");onComplete(nil);return}
            onComplete( hccqrImage )
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
      guard let data:Data = str.data(using: .utf8) else { Swift.print("getHCCQRImage() - ⚠️️ data err ⚠️️ "); onComplete(nil);return}
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
public typealias OnHCCQRImageComplete = (_ hccqrImage:Image?) -> Void
public typealias OnHCCQRDataComplete = (_ payload:Data?) -> Void
