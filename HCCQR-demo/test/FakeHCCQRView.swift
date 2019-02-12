import UIKit
@testable import HCCQR_lib_iOS
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
 */
class FakeHCCQRView:UIView{
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
extension FakeHCCQRView{
   /**
    * Creates 4x4 color-grid
    */
   func createColorGrid(){
      let grid:[[UIColor]] = {
         [
            [.red,.green,.blue,.white],
            [.green,.red,.white,.blue],
            [.blue,.green,.red,.white],
            [.green,.white,.blue,.red]
         ]
      }()
      /*Place the grid of color rectangles*/
      grid.enumerated().forEach{ row in
         row.element.enumerated().forEach{ (e,color) in
            let layer = self.createLayer(color: color,size:.init(width:80,height:80))
            layer.frame.origin.x = CGFloat(e * 80)
            layer.frame.origin.y = CGFloat(row.offset * 80)
            self.layer.addSublayer(layer)
         }
      }
   }
}
