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
    * creates 3 color squares
    */
   func createColorGrid() {
      let pixelColors = [Pixel.Colors.redish, Pixel.Colors.green, Pixel.Colors.blue]
      Swift.print("Pixel.Colors.redish:  \(Pixel.Colors.redish)")
      Swift.print("Pixel.Colors.redish.color:  \(Pixel.Colors.redish.color)")
      let colors: [UIColor] = pixelColors.map { $0.color } // [UIColor.red, .green, .blue]
      colors.enumerated().forEach { i, color in
         let layer = self.createLayer(color: color)
         layer.frame.origin.x = CGFloat(i * 100)
         self.layer.addSublayer(layer)
      }
   }
}
#endif
