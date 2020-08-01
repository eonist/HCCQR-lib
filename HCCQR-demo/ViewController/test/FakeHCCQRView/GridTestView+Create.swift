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
            [PixelData.greenish.color, PixelData.blackish.color, PixelData.whiteish.color, PixelData.blueish.color, PixelData.redish.color],
            [PixelData.whiteish.color, PixelData.blueish.color, PixelData.blueish.color, PixelData.redish.color, PixelData.greenish.color],
            [PixelData.blueish.color, PixelData.blackish.color, PixelData.redish.color, PixelData.greenish.color, PixelData.blueish.color],
            [PixelData.whiteish.color, PixelData.greenish.color, PixelData.greenish.color, PixelData.greenish.color, PixelData.redish.color],
            [PixelData.redish.color, PixelData.blueish.color, PixelData.greenish.color, PixelData.redish.color, PixelData.greenish.color]
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
