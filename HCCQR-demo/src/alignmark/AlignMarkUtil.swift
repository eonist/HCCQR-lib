import UIKit

//AimImg = View.snapshot
//Result = Composit(HccqrIMG,aimImg
//
//When u separate, you need to remove the pizels you take away, and overrite these areas.
//Or
//Grab all blackidh colors and Add them to final QR img. So u Get the aim boxes.
//You could also Draw aim stuff in say yellow. 🤷
//you can make black stuff black inside the qrSquareBoundingBox 👌


class AlignMarkUtil{
   /**
    * Creates an UIIMageView with the Align marks drawn into the image
    * - TODO: ⚠️️ add support for secondary align marks
    */
   static func alignMarkGraphic(qrImgSize:CGSize, strCount:Int) -> UIImageView {
      let metric:AlignBoxMetric = {
         let small = AlignMarkUtil.small.charRange
         let medium = AlignMarkUtil.medium.charRange
         let big = AlignMarkUtil.big.charRange
         if strCount >= small.start || strCount < small.end {
            return AlignMarkUtil.small.metric
         }else if  strCount >= medium.start || strCount < medium.end {
            return AlignMarkUtil.medium.metric
         }else if  strCount >= big.start || strCount < big.end {
            return AlignMarkUtil.big.metric
         }else {
            fatalError("type not supported")
         }
      }()
      let view:UIView = drawSquares(view:.init(), qrImgSize:qrImgSize, metric:metric)
      let img:UIImage? = view.snapShot
      let imageView:UIImageView = .init(image:img)
      return imageView
   }
   /**
    * Draw align marks
    */
   private static func drawSquares(view:UIView, qrImgSize:CGSize, metric:AlignBoxMetric) -> UIView {
      let primaryPoints:[CGPoint] = {
         let tl = AlignMarkUtil.topLeft(metric:metric)
         let tr = AlignMarkUtil.topRight(qrImgSize:qrImgSize,metric:metric)
         let bl = AlignMarkUtil.bottomLeft(qrImgSize:qrImgSize,metric:metric)
         return [tl,tr,bl]
      }()
      /*Draw the shapeLayers into the view*/
      primaryPoints.forEach {
         let square:(black:CAShapeLayer,white:CAShapeLayer) = drawSquare(metric:metric,pos:$0)
         view.layer.addSublayer(square.black)
         view.layer.addSublayer(square.white)
      }
      return view
   }
   /**
    * Draws the primary align marks
    */
   private static func drawSquare(metric:AlignBoxMetric, pos:CGPoint) -> (black:CAShapeLayer,white:CAShapeLayer){
      let rect:CGRect = .init(x:0,y:0,width:metric.length,height:metric.length)
      let blackShape = CGShapeUtil.drawRect(shapeLayer:.init(),rect:rect, style:(nil,.black,metric.thickness))
      let whiteShape:CAShapeLayer = {
         let inset:UIEdgeInsets = UIEdgeInsets.init(top: metric.thickness, left: metric.thickness, bottom: metric.thickness, right: metric.thickness)
         let whiteLineRect:CGRect = rect.inset(by: inset)
         return CGShapeUtil.drawRect(shapeLayer:.init(),rect:whiteLineRect, style:(nil,.white,metric.thickness))
      }()
      return (black:blackShape, white:whiteShape)
   }
}
/**
 * Metrics
 * - TODO: ⚠️️ Remove length, its always 6x the thickness 👌
 */
extension AlignMarkUtil {
   typealias CharRange = (start:Int, end:Int)
   typealias AlignBoxMetric = (length:CGFloat, thickness:CGFloat)
   typealias AlignBoxType = (charRange:CharRange, metric:AlignBoxMetric)
   private static let small:AlignBoxType = (charRange:(0,100),metric:(24*6,24))
   private static let medium:AlignBoxType = (charRange:(100,200),metric:(20*6,20))
   private static let big:AlignBoxType = (charRange:(0,100),metric:(16*6,16))
   static let alignBoxSizes:[AlignBoxType] = [small,medium,big]
}
/**
 * Metrics
 */
extension AlignMarkUtil {
   static func topLeft(metric:AlignBoxMetric) -> CGPoint {
      return .init(x:metric.thickness,y:metric.thickness)
   }
   static func topRight(qrImgSize:CGSize, metric:AlignBoxMetric) -> CGPoint {
      return .init(x:qrImgSize.width - metric.length - metric.thickness, y:metric.thickness)
   }
   static func bottomLeft(qrImgSize:CGSize, metric:AlignBoxMetric) -> CGPoint {
      return .init(x:metric.thickness, y:qrImgSize.height - metric.length - metric.thickness)
   }
}
