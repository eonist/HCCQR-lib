#if os(iOS)
import UIKit
/**
 * UIView extensions
 */
extension UIView {
   /**
    * Creates UIImage from a view
    * - Important: ⚠️️ if you get the "invalid context 0x0" error, make sure your View has a frame. view.bounds must not be .zero
    * - Fixme: ⚠️️ Add a throw error if frame is zero
    */
   var snapShot: UIImage? {
      UIGraphicsBeginImageContextWithOptions(self.bounds.size, true, UIScreen.main.scale)
      self.layer.render(in: UIGraphicsGetCurrentContext()!)
      let img = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
      return img
   }
   var snapshot2: UIImage? {
      if #available(iOS 10, *) {
         Swift.print("self.bounds:  \(self.bounds)")
         let renderer = UIGraphicsImageRenderer(bounds: self.bounds)
         return renderer.image { context in
            self.layer.render(in: context.cgContext)
         }
      } else {
         UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0)
         if let renderer = UIGraphicsGetCurrentContext() {
            _ = renderer
            drawHierarchy(in: bounds, afterScreenUpdates: true)
            let screenshot = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return screenshot
         }
         return nil
      }
   }
   // the old snapshot
   //      UIGraphicsBeginImageContextWithOptions(self.frame.size, false, 0) // <- scale
   //      self.drawHierarchy(in: self.frame, afterScreenUpdates: true)
   //      let image: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
   //      UIGraphicsEndImageContext()
   //      return image
   /**
    * Creates a CALayer with a color
    * - Parameters:
    *   - color: The color to fill the layer with
    *   - size: The size of the layer
    */
   func createLayer(color: UIColor, size: CGSize = .init(width: 100, height: 100)) -> CALayer {
      let layer: CALayer = .init()
      layer.frame = .init(origin: .zero, size: size)
      layer.backgroundColor = color.cgColor
      return layer
   }
}
//extension CALayer {
//   /**
//    *
//    */
//   func makeSnapshot() -> UIImage? {
//      let scale = UIScreen.main.scale
//      UIGraphicsBeginImageContextWithOptions(frame.size, false, scale)
//      defer { UIGraphicsEndImageContext() }
//      guard let context = UIGraphicsGetCurrentContext() else { return nil }
//      render(in: context)
//      let screenshot = UIGraphicsGetImageFromCurrentImageContext()
//      return screenshot
//   }
//}
#endif
