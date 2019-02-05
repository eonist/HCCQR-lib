import Foundation
/**
 * QR Error Correction level (ECLevel)
 * L - [Default] Allows recovery of up to 7% data loss
 * M - Allows recovery of up to 15% data loss
 * Q - Allows recovery of up to 25% data loss
 * H - Allows recovery of up to 30% data loss
 * ## Examples:
 * Swift.print(ECLevels.allCases[1].rawValue)//"M"
 */
public enum ECLevel:String,CaseIterable {
   case l = "L"
   case m = "M"
   case q = "Q"
   case h = "H"
}
