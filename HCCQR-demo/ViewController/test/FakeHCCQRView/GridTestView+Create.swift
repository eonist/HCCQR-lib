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
            [Pixel.greenish.color, Pixel.blackish.color, Pixel.whiteish.color, Pixel.blueish.color, Pixel.redish.color],
            [Pixel.whiteish.color, Pixel.blueish.color, Pixel.blueish.color, Pixel.redish.color, Pixel.greenish.color],
            [Pixel.blueish.color, Pixel.blackish.color, Pixel.redish.color, Pixel.greenish.color, Pixel.blueish.color],
            [Pixel.whiteish.color, Pixel.greenish.color, Pixel.greenish.color, Pixel.greenish.color, Pixel.redish.color],
            [Pixel.redish.color, Pixel.blueish.color, Pixel.greenish.color, Pixel.redish.color, Pixel.greenish.color]
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
