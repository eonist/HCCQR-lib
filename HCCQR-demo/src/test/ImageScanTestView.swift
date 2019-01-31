
import UIKit
import QRLibIOS


class ImageScanTestView:UIView{
   /**
    * Initiate
    */
   override init(frame: CGRect) {
      super.init(frame: frame)
      let strings:[String] = {
         let string1:String = String(repeating: "9", count: Int(38)) + "5"//+ "z"//270
         let string2:String = String(repeating: "a", count: 243)
         let string3:String = String(repeating: "84", count: 42)
         return [string1,string2,string3]
      }()
      var versions:[Int?] = []
      /*scan*/
      let scanComplete:ImageScanner.ScanComplete = { version in
         versions.append(version)
         if versions.count == strings.count {/*WHen all scans have completed*/
            Swift.print("versions:  \(versions)")
         }
      }
      strings.forEach{ string in
         /*Create Image*/
         ImageScanner.scanImage(string: string, size:.init(width:375,height:375), ecLevel:.l, scanComplete: scanComplete)
      }
   }
   /**
    * Boilerplate
    */
   required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
}
