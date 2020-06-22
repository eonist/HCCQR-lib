#if os(iOS)
import UIKit
//@testable import HCCQR_lib
/**
 * Creates a (red,green,blue) image
 * - Note: used to debug extracting RGBA channels
 * - Fixme: ⚠️️ This needs something to test
 * ## Examples:
 * let splitView = SplitTestView(frame: .init(origin: .zero, size: .init(width: 300, height: 100)))
 * view.addSubview(splitView)
 */
class SplitTestView: UIView {
   static let width: CGFloat = height * 3
   static let height: CGFloat = 100
   override init(frame: CGRect) {
      let frame: CGRect = .init(origin: .zero, size: .init(width: SplitTestView.width, height: SplitTestView.height))
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
extension SplitTestView {
   /**
    * creates 3 color squares
    */
   func createColorGrid() {
      let pixelColors = [Pixel.Colors.redish, Pixel.Colors.greenish, Pixel.Colors.blueish] // [Pixel.Colors.greenish]//
//      Swift.print("Pixel.Colors.greenish:  \(Pixel.Colors.greenish)")
//      Swift.print("Pixel.Colors.greenish.color:  \(Pixel.Colors.greenish.color)")
//      Swift.print("Pixel.Colors.redish:  \(Pixel.Colors.redish)")
//      Swift.print("Pixel.Colors.redish.color:  \(Pixel.Colors.redish.color)")
      let colors: [UIColor] = pixelColors.map { $0.color } // [UIColor.red, .green, .blue]
      colors.enumerated().forEach { i, color in
         let layer = self.createLayer(color: color, size: .init(width: SplitTestView.height, height: SplitTestView.height))
         layer.frame.origin.x = CGFloat(i) * SplitTestView.height
         self.layer.addSublayer(layer)
      }
   }
}
#endif
