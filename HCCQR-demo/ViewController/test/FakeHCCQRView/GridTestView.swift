#if os(iOS)
import UIKit
//@testable import HCCQR_lib
/**
 * This class creates a grid of colors to simulate a HCCQR pallet (For testing reading HCCQR)
 * - Note: These are the channel filled,unfilled represenations: (black = 1, white = 0)
 * - Red = 01
 * - Green = 10
 * - Blue = 11
 * - White = 00
 * - Note: you only need to invert layer items that are zero 👈
 * - Note: layer 1 needs green and blue (the other colors are blank)
 * - Note: layer 2 needs red and blue (the other colors are blank)
 * - Fixme: ⚠️️ This needs something to test
 * - Fixme: ⚠️️ rename to GridTestView?
 * ## Examples
 * let demoView = FakeHCCQRView.init(.init(origin: .init(x: 0, y: 0), size: .init(width: 100, height: 100)))
 * addSubview(demoView)
 */
class GridTestView: UIView {
   static let frame: CGRect = .init(origin: .init(x: 0, y: 0), size: .init(width: GridTestView.size.width * GridTestView.xCount, height: GridTestView.size.height * GridTestView.yCount))
   static let xCount: CGFloat = 5
   static let yCount: CGFloat = 5
   static let size: CGSize = .init(width: 30, height: 30)
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
#endif
