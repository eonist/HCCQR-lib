import UIKit
/**
 *
 */
extension UIView{
   /**
    * Creates UIImage from a view
    * - Important: ⚠️️ if you get the "invalid context 0x0" error, make sure your View has a frame. view.bounds must not be .zerp
    */
   var snapShot:UIImage?{
      UIGraphicsBeginImageContextWithOptions(self.frame.size, false, 0/*<-scale*/)
      self.drawHierarchy(in: self.frame, afterScreenUpdates: true)
      let image:UIImage? = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
      return image
   }
   /**
    * Creates a calayer with a color
    */
   func createLayer(color:UIColor, size:CGSize = .init(width: 100, height: 100)) -> CALayer{
      let layer:CALayer = .init()
      layer.frame = .init(origin: .zero, size: size)
      layer.backgroundColor = color.cgColor
      return layer
   }
}
