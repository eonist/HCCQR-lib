import UIKit
import QRLibIOS

class ViewController: UIViewController {
   /**
    * Test
    */
   override func viewDidLoad() {
      super.viewDidLoad()
      view.backgroundColor = .lightGray
//      testSeperation()
//      testFakeHCCQRView()
//      testComposition()
//      testSimpleHCCQRView()
//      testHCCQRWithTwoQRViews()
//      testAimMarks()
//      testingVersion()
//      testCreatingQRImage()
//      testQRVersions()
//     testModuleCount()
     
//      testHCCQRImage()
     
//      testReadingHCCQRImage()
//      colorTests()
      testingSmallModuleSize()
//      testScalingArray()
      
      //🏀
      //make an RGBAImage that has 4 pixels, then try to scale that picture ✅
      //time things, whats taking long? 👈
      // keep refatoring 👈
      // try to improve the color seperation process
      
   }
   override var prefersStatusBarHidden:Bool {return true}/*hides statusbar*/
}
extension ViewController{
   /**
    * Scale array
    */
   func testScalingArray(){
      let scale = 2
      
      let a1 = [0,1,1,0]
      
      let arr1 = scaleArr(arr:a1,size:(width:2,height:2),scale:2)
      Swift.print(arr1)
      Swift.print("arr1.count:  \(arr1.count)")
      let count1 = a1.count*scale*scale
      Swift.print("count1:  \(count1)")
      //00,11
      //00,11
      //11,00
      //11,00
      let a2 = [0,0,0, 1,0,1, 0,0,0]
      let arr2 = scaleArr(arr:a2,size:(width:3,height:3),scale:2)
      Swift.print(arr2)
      Swift.print("arr2.count:  \(arr2.count)")
      let count2 = a2.count*scale*scale
      Swift.print("count2:  \(count2)")
      //000,000
      //000,000
      //110,011
      //110,011
      //000,000
      //000,000
   }
   /**
    * Scales an array in both x and y axis
    * # Examples:
    * Swift.print(scaleArr(arr:[0,1,1,0],size:(width:2,height:2),scale:2))//[0, 0, 1, 1, 0, 0, 1, 1, 1, 1, 0, 0, 1, 1, 0, 0]
    * Swift.print(scaleArr(arr:[0,0,0, 1,0,1, 0,0,0],size:(width:3,height:3),scale:2))//[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 1, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    */
   func scaleArr(arr:[Int],size:(width:Int,height:Int),scale:Int) -> [Int]{
      return (0..<size.width*2).flatMap{ x in
         return (0..<size.height*2).map{ y in
            let i = x/2*size.width+y/2
            let item:Int = arr[i]
            return item
         }
      }
   }
}
