#if os(iOS)
//@testable import HCCQR_lib
import UIKit
/**
 * Create
 */
extension BWGridView {
   /**
    * Create view 1
    */
   func createView1() -> UIView {
      let view: UIView = .init(frame: self.bounds)
      addSubview(view)
      BWGridView.createBWGrid(view: view, grid: BWGridView.grid1)
      return view
   }
   /**
    * Create view 2
    */
   func createView2() -> UIView {
      let view: UIView = .init(frame: self.bounds)
      addSubview(view)
      BWGridView.createBWGrid(view: view, grid: BWGridView.grid2)
      return view
   }
   /**
    * Creates 4x4 black-and-white-grid
    */
   static func createBWGrid(view: UIView, grid: [[UIColor]]) {
      /*Place the grid of color rectangles*/
      grid.enumerated().forEach { row in
         row.element.enumerated().forEach { e, color in
            let layer = view.createLayer(color: color, size: .init(width: 80, height: 80))
            layer.frame.origin.x = CGFloat(e * 80)
            layer.frame.origin.y = CGFloat(row.offset * 80)
            view.layer.addSublayer(layer)
         }
      }
   }
}
#endif
