#if os(iOS)
import UIKit
//@testable import HCCQR_lib_iOS
/**
 * Creates a HCCQR pallet based on 2 layers of black and white grids
 */
class SimpleHCCQRView: UIView {
   lazy var view1: UIView = createView1()
   lazy var view2: UIView = createView2()
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
#endif
