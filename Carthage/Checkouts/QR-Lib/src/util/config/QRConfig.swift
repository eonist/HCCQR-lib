/**
 * Stores essential qr config parameters
 * ## Examples:
 * let config:QRConfig = (10,.byte,.l)
 * let version:Int = QRVersion.version(dataCount:230, qrMode:.byte, ecLevel:.l)//10
 * let mode:QRMode = QRMode.mode(string:"abcd123")//.byte
 * let ecLevel:ECLevel = .l
 */
public typealias QRConfig = (version: Int, mode: QRMode, ecLevel: ECLevel)

public class QRConfigUtil {
   /**
    * Returns dataCount for qrversion,qrmode,ecLevel
    * ## Examples:
    * QRConfigUtil.dataCount(config:(10,.byte,.l))//271
    */
   public static func dataCount(config: QRConfig) -> Int? {
      let dataCount: Int? = QRVersion.maxChar(qrVersion: config.version, qrMode: config.mode, ecLevel: config.ecLevel)
      return dataCount
   }
}
