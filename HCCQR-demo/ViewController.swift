import UIKit

class ViewController: UIViewController {

   override func viewDidLoad() {
      super.viewDidLoad()
      view.backgroundColor = .lightGray
      let rgbColorTestView = RGBColorTestView(frame:CGRect.init(origin: .zero, size: .init(width: 300, height: 100)))
      view.addSubview(rgbColorTestView)
      
      guard let rgbColorTestImage:UIImage = rgbColorTestView.snapShot else {fatalError("err")}
      //let rgba3 = RGBAImage(image: UIImage(named: "monet")!)!
      guard let images:RGBAImage.RGBImages = RGBAImage.split(image: rgbColorTestImage) else {fatalError("err")}
//      //r
//      guard let rgbaImage:RGBAImage = RGBAImage.init(image: rgbColorTestImage) else {fatalError("err")}
//      let rgbaImage2:RGBAImage = rgbaImage.copy
      
//      let rChannel:RGBAImage = RGBAImage.channelR(rgbaImage)
//      let rImage:UIImage? = RGBAImage.image(rgbaImage: rChannel)
//      let rImageView:UIImageView = UIImageView.init(image: rImage)
//      view.addSubview(rImageView)
//      rImageView.frame.origin.y = 100
      
      
      
      let rImageView:UIImageView = UIImageView.init(image: images.r)
      view.addSubview(rImageView)
      rImageView.frame.origin.y = 200

      //g
//      guard let rgbaImage2:RGBAImage = RGBAImage.init(image: rgbColorTestImage) else {fatalError("err")}
//      let gChannel:RGBAImage = RGBAImage.channelG(rgbaImage2)
//      let gImage:UIImage? = RGBAImage.image(rgbaImage: gChannel)
//      let gImageView:UIImageView = UIImageView.init(image: gImage)
//      view.addSubview(gImageView)
//      gImageView.frame.origin.y = 200
      
      
      let gImageView:UIImageView = UIImageView.init(image: images.g)
      view.addSubview(gImageView)
      gImageView.frame.origin.y = 300
      //b
      let bImageView:UIImageView = UIImageView.init(image: images.b)
      view.addSubview(bImageView)
      bImageView.frame.origin.y = 400
   }
   override var prefersStatusBarHidden:Bool {return true}/*hides statusbar*/
   
}

class RGBColorTestView:UIView{
   override init(frame: CGRect) {
      super.init(frame: frame)
      
      [UIColor.red,.green,.blue].enumerated().forEach{ (i,color) in
         let layer = RGBColorTestView.createLayer(color: color)
         layer.frame.origin.x = CGFloat(i * 100)
         self.layer.addSublayer(layer)
      }
   }
   
   required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   /**
    * New
    */
   static func createLayer(color:UIColor)->CALayer{
      let layer:CALayer = CALayer.init()
      layer.frame = CGRect.init(origin: .zero, size: .init(width: 100, height: 100))
      layer.backgroundColor = color.cgColor
      return layer
   }
}

extension UIView{
   /**
    * Creates UIImage from a view
    */
   var snapShot:UIImage?{
      UIGraphicsBeginImageContextWithOptions(self.frame.size, false, 0)
      self.drawHierarchy(in: self.frame, afterScreenUpdates: true)
      let image:UIImage? = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
      return image
   }
}
