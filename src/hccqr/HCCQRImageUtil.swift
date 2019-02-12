#if os(iOS)
import UIKit
import QRLibIOS
#elseif os(macOS)
import Cocoa
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
    */
   public static func getHCCQRImage(string str:String, qrVersion:Int, qrMode:QRMode, ecLevel:ECLevel, scale:Int, onComplete: @escaping OnGetHCCQRImageComplete)  {
      let moduleCount:Int = QRModuleUtil.moduleCount(version: qrVersion)/*Sort of like QRPixels*/
      let firstPart:String = String(str[..<str.index(str.startIndex, offsetBy: str.count/2)])/*First part of the payload*/
      let lastPart:String = String(str[str.index(str.startIndex, offsetBy: str.count/2)...])/*Second part of the payload*/
      let length:CGFloat = CGFloat(moduleCount + 2) /*the 2 extra are margins*/
      let strings:[String] = [firstPart,lastPart]
      var qrImgs:[Image?] = [Image?](repeating: nil, count: strings.count)
      func onCreateQrImgComplete(i:Int,qrImg:UIImage?){
         guard let qrImg:Image = qrImg else { Swift.print("onCreateQrImgComplete() - ⚠️️ qrImg err ⚠️️ "); onComplete(nil);return}
         qrImgs[i] = qrImg//it matters which order the qrImages came in when you stitch them back together
         if qrImgs.first(where: {$0 == nil}) == nil {/*makes sure all images finished*/
            let qrImages:[Image] = qrImgs.compactMap{$0}
            guard let hccqrImage:Image = Colorize.colorize(images: qrImages, colorMap: Colorize.colorMap, scale:scale/*blandColorMap*/) else {Swift.print("Unable to create colorized image");onComplete(nil);return}
            onComplete( hccqrImage )
         }
      }
      strings.enumerated().forEach { arg in
         DispatchQueue.global(qos:.background).async {
            let qrImg:Image? = QRImageUtil.qrImage(str: arg.element, size: .init(width:length,height:length), ecLevel: ecLevel)
            DispatchQueue.main.async{
               onCreateQrImgComplete(i:arg.offset,qrImg: qrImg)
            }
         }
      }
   }
}
/**
 * Type
 */
extension HCCQRImageUtil{
   public typealias OnGetHCCQRImageComplete = (Image?)->Void
}
