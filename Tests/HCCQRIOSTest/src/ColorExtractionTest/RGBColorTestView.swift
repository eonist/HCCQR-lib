#if os(iOS)
import UIKit
#if os(iOS)
@testable import HCCQR_lib
#elseif os(macOS)
@testable import HCCQR_demo_mac
#endif
/**
 * Creates a (red,green,blue) image
 * - Note: used to debug extracting RGBA channels
 * - Fixme: ⚠️️ This needs something to test
 */
class RGBColorTestView: UIView {
   override init(frame: CGRect) {
      super.init(frame: frame)
      [UIColor.red, .green, .blue].enumerated().forEach { i, color in
         let layer = self.createLayer(color: color)
         layer.frame.origin.x = CGFloat(i * 100)
         self.layer.addSublayer(layer)
      }
   }
   /**
    * Boilerplate
    */
   required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
}
#endif
