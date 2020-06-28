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
            [Pixel.Colors.greenish.color, Pixel.Colors.blackish.color, Pixel.Colors.whiteish.color, Pixel.Colors.blueish.color, Pixel.Colors.redish.color],
            [Pixel.Colors.whiteish.color, Pixel.Colors.blueish.color, Pixel.Colors.blueish.color, Pixel.Colors.redish.color, Pixel.Colors.greenish.color],
            [Pixel.Colors.blueish.color, Pixel.Colors.blackish.color, Pixel.Colors.redish.color, Pixel.Colors.greenish.color, Pixel.Colors.blueish.color],
            [Pixel.Colors.whiteish.color, Pixel.Colors.greenish.color, Pixel.Colors.greenish.color, Pixel.Colors.greenish.color, Pixel.Colors.redish.color],
            [Pixel.Colors.redish.color, Pixel.Colors.blueish.color, Pixel.Colors.greenish.color, Pixel.Colors.redish.color, Pixel.Colors.greenish.color]
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
