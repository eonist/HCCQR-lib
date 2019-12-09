import Foundation
import QR_lib
/**
 * Type
 */
extension HCCQRWriter {
   public typealias QRConfig = (qrVersion: Int, ecLevel: ECLevel)
   typealias Multipliers = (moduleScale: Int, screenScale: Int)
}
/**
 * Useful when you setup the callbacks in apps (Thats why they are in public scope)
 */
public typealias OnHCCQRImageComplete = (_ hccqrImage: Image?, _ error: Error?) -> Void
