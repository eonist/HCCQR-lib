#if os(iOS)
import UIKit
//@testable import HCCQR_lib
/**
 * Create
 */
extension FakeHCCQRView {
   /**
    * Creates 4x4 color-grid
    */
   func createColorGrid() {
      let grid: [[UIColor]] = {
         [
            [.red, .green, .blue, .white],
            [.green, .blue, .white, .blue],
            [.blue, .green, .red, .white],
            [.green, .white, .blue, .red]
         ]
      }()
      grid.enumerated().forEach { row in // Place the grid of color rectangles
         row.element.enumerated().forEach { e, color in
            let layer = self.createLayer(color: color, size: FakeHCCQRView.size)
            layer.frame.origin.x = CGFloat(e) * FakeHCCQRView.size.width
            layer.frame.origin.y = CGFloat(row.offset) * FakeHCCQRView.size.height
            self.layer.addSublayer(layer)
         }
      }
   }
}
#endif
