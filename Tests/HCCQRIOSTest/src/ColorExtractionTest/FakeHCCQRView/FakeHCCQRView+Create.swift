#if os(iOS)
import UIKit
#if os(iOS)
@testable import HCCQR_lib
#elseif os(macOS)
@testable import HCCQR_demo_mac
#endif
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
            [.green, .red, .white, .blue],
            [.blue, .green, .red, .white],
            [.green, .white, .blue, .red]
         ]
      }()
      /*Place the grid of color rectangles*/
      grid.enumerated().forEach { row in
         row.element.enumerated().forEach { e, color in
            let layer = self.createLayer(color: color, size: .init(width: 80, height: 80))
            layer.frame.origin.x = CGFloat(e * 80)
            layer.frame.origin.y = CGFloat(row.offset * 80)
            self.layer.addSublayer(layer)
         }
      }
   }
}
#endif
