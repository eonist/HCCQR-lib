import UIKit
import QRLibIOS

class ViewController: UIViewController {

   override func viewDidLoad() {
      super.viewDidLoad()
      
      let image = QRUtil.qrImage(str: "testing", size: .init(width:100,height:100))
      _ = image
   }
}
