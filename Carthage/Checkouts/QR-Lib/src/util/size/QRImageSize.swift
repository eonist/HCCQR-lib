import Foundation
/**
 * Helper
 */
public class QRImageSize{
   /**
    * Returns enough size to hold the provided string (approximately)
    * - Discussion: this is sort of a naive approach, as it doesnt account for ErrorCorrection, QRMode etc, this could be improved in the future
    * - TODO: ⚠️️ Account for QRMode etc improved this the future
    * - Important: ⚠️️ the sizes are a little overkill, can be improved (But they do render, even at 6000x6000)
    */
   public static func qrImageSize(string:String,ecLevel:ECLevel ) -> CGSize{
      let length:CGFloat = {
         if string.count < 100 {
            return 200/*Sometimes 100 can be too little for numeric QR, but 200 seems enough*/
         }else if string.count < 200 {
            return 200
         }else if string.count < 400 {
            return 400
         }else if string.count < 600 {
            return 600
         }else if string.count < 800 {
            return 800
         }else if string.count < 1000 {
            return 1000
         }else if string.count < 2000 {
            return 2000
         }else if string.count < 3000{
            return 3000
         }else {
            return 4000/*Should be enough size for version 40 etc, but who knows, at these sizes things get complicated*/
         }
      }()
      let multiplier:CGFloat = ecLevel == .h ? 2 : 1
      return .init(width:length*multiplier,height:length*multiplier)
   }
}

