#if os(iOS)
import UIKit
//@testable import HCCQR_lib
/**
 * Create
 */
extension GridTestView {
   /**
    * Creates 4x4 color-grid
    */
   func createColorGrid() {
      let grid: [[UIColor]] = {
         [
            [.green, .blue, .red, .blue, .red],
            [.red, .blue, .blue, .red, .green],
            [.blue, .green, .red, .green, .blue],
            [.green, .green, .green, .green, .red],
            [.red, .blue, .blue, .red, .green]
         ]
      }()
      grid.enumerated().forEach { row in // Place the grid of color rectangles
         row.element.enumerated().forEach { e, color in
            let layer = self.createLayer(color: color, size: GridTestView.size)
            layer.frame.origin.x = CGFloat(e) * GridTestView.size.width
            layer.frame.origin.y = CGFloat(row.offset) * GridTestView.size.height
            self.layer.addSublayer(layer)
         }
      }
   }
}
#endif
