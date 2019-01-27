import UIKit
/**
 * Creates a HCCQR pallet based on 2 layers of black and white grids
 */
class SimpleHCCQRView:UIView{
   lazy var view1:UIView = createView1()
   lazy var view2:UIView = createView2()
   /**
    * Initiate
    */
   override init(frame: CGRect) {
      super.init(frame: frame)
      _ = view1
      _ = view2
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
extension SimpleHCCQRView{
   /**
    * Create view 1
    */
   func createView1()->UIView{
      let view:UIView = .init(frame: self.bounds)
      addSubview(view)
      SimpleHCCQRView.createBWGrid(view: view, grid: SimpleHCCQRView.grid1)
      return view
   }
   /**
    * Create view 2
    */
   func createView2()->UIView{
      let view:UIView = .init(frame: self.bounds)
      addSubview(view)
      SimpleHCCQRView.createBWGrid(view: view, grid: SimpleHCCQRView.grid2)
      return view
   }
   /**
    * Creates 4x4 black-and-white-grid
    */
   static func createBWGrid(view:UIView,grid:[[UIColor]]){
      /*Place the grid of color rectangles*/
      grid.enumerated().forEach{ row in
         row.element.enumerated().forEach{ (e,color) in
            let layer = view.createLayer(color: color,size:.init(width:80,height:80))
            layer.frame.origin.x = CGFloat(e * 80)
            layer.frame.origin.y = CGFloat(row.offset * 80)
            view.layer.addSublayer(layer)
         }
      }
   }
}
/**
 * Data
 */
extension SimpleHCCQRView{
   static let grid1:[[UIColor]] = {
      [
         [.black,.white,.black,.white],
         [.white,.black,.white,.black],
         [.black,.black,.white,.white],
         [.white,.white,.black,.black]
      ]
   }()
   static let grid2:[[UIColor]] = {
      [
         [.white,.white,.black,.black],
         [.white,.black,.white,.black],
         [.black,.white,.black,.white],
         [.black,.black,.white,.white]
      ]
   }()
}

