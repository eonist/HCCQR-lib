import Foundation
#if os(iOS)
import QRLibIOS
#elseif os(macOS)
import QRLibMac
#endif

public class HCCQRStringData {
   /**
    * Returns a max random string for version,mode,ecLevel
    */
   public static func randomString(qrVersion: Int, qrMode: QRMode, ecLevel: ECLevel) -> String? {
      guard let stringCount: Int = QRVersion.maxChar(qrVersion: qrVersion, qrMode: qrMode, ecLevel: ecLevel) else { Swift.print("⚠️️ Unable to get stringCount ⚠️️"); return nil }//533
      let strCount: Int = stringCount * 2/*we want double count for HCCQR*/
      let randomString: String = QRStringData.randomString(max: strCount, qrMode: .byte)
      return randomString
   }
}
