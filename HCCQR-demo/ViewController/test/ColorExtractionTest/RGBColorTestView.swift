#if os(iOS)
import UIKit
//@testable import HCCQR_lib
/**
 * Creates a (red,green,blue) image
 * - Note: used to debug extracting RGBA channels
 * - Fixme: ⚠️️ This needs something to test
 * ## Examples:
 * let rgbColorTestView = RGBColorTestView(frame: .init(origin: .zero, size: .init(width: 300, height: 100)))
 * view.addSubview(rgbColorTestView)
 */
class RGBColorTestView: UIView {
   override init(frame: CGRect) {
      super.init(frame: frame)
      createColorGrid()
   }
   /**
    * Boilerplate
    */
   required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
}
/**
 * Create
 */
extension RGBColorTestView {
   /**
    *creates 3 color squares
    */
   func createColorGrid() {
      [UIColor.red, .green, .blue].enumerated().forEach { i, color in
         let layer = self.createLayer(color: color)
         layer.frame.origin.x = CGFloat(i * 100)
         self.layer.addSublayer(layer)
      }
   }
}
#endif
