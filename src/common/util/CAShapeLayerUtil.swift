import UIKit

internal class CGShapeUtil {
   /**
    * Draws a rectange in shapeLayer
    * ## Examples:
    * let rectShape = CGShapeUtil.drawRect(shapeLayer:.init(),.init(x:0,y:0,width:100,height:100),style(nil,.black,14))
    * view.layer.addSublayer(rectShape)
    */
   static func drawRect(shapeLayer: CAShapeLayer, rect: CGRect, style: (fillColor: UIColor?, strokeColor: UIColor?, thickness: CGFloat?)?) -> CAShapeLayer {
      let path: CGMutablePath = .init()
      path.addRect(rect)
      shapeLayer.path = path
      shapeLayer.strokeColor = style?.strokeColor?.cgColor
      shapeLayer.lineWidth = style?.thickness ?? shapeLayer.lineWidth
      shapeLayer.fillColor = style?.fillColor?.cgColor
      return shapeLayer
   }
}
