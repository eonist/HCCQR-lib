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
      Swift.print("alignMarkGraphic.strCount:  \(strCount)")
      let metric:AlignBoxMetric = {
         let (small,medium,big) = (AlignMarkUtil.small.charRange,AlignMarkUtil.medium.charRange,AlignMarkUtil.big.charRange)
         if strCount >= small.start && strCount < small.end {
//            Swift.print("small")
            return AlignMarkUtil.small.metric
         }else if  strCount >= medium.start && strCount < medium.end {
//            Swift.print("medium")
            return AlignMarkUtil.medium.metric
         }else if  strCount >= big.start && strCount <= big.end {
//            Swift.print("big")
            return AlignMarkUtil.big.metric
         }else {
            return AlignMarkUtil.big.metric
            Swift.print("type not supported")
         }
      }()
      let viewRect:CGRect = .init(origin:.zero,size:qrImgSize)
      let view:UIView = drawSquares(view:.init(frame:viewRect), qrImgSize:qrImgSize, metric:metric)
      let img:UIImage? = view.snapShot
      let imageView:UIImageView = .init(image:img)
      return imageView
   }
}
/**
 * Helper
 */
extension AlignMarkUtil{
   /**
    * Draw align marks
    */
   fileprivate static func drawSquares(view:UIView, qrImgSize:CGSize, metric:AlignBoxMetric) -> UIView {
      let primaryPoints:[CGPoint] = {
         let tl = AlignMarkUtil.topLeft()
         let tr = AlignMarkUtil.topRight(qrImgSize:qrImgSize,markLength:metric.squareLength)
         let bl = AlignMarkUtil.bottomLeft(qrImgSize:qrImgSize,markLength:metric.squareLength)
         return [tl,tr,bl]
      }()
      /*Draw the shapeLayers into the view*/
      primaryPoints.forEach {
         let square = drawDebugSquare(metric:metric,pos:$0)//drawSquare
         view.layer.addSublayer(square.0)
         view.layer.addSublayer(square.1)
      }
      return view
   }
   /**
    * Draws the primary align marks
    */
//   fileprivate static func drawSquare(length:CGFloat, pos:CGPoint) -> (CAShapeLayer,CAShapeLayer){
//      let rect:CGRect = .init(x:pos.x,y:pos.y,width:length*8,height:length*8)
//      let blackShape:CAShapeLayer = {
//         let insetAmount:CGFloat = length
//         let inset:UIEdgeInsets = .init(top: insetAmount, left: insetAmount, bottom: insetAmount, right: insetAmount)
//         let rect:CGRect = rect.inset(by: inset)
//         return CGShapeUtil.drawRect(shapeLayer:.init(),rect:rect, style:(.black,nil,nil))
//      }()
//      let whiteShape:CAShapeLayer = {
//         let insetAmount:CGFloat = (length*2) + (length/2)
//         let inset:UIEdgeInsets = .init(top: insetAmount, left: insetAmount, bottom: insetAmount, right: insetAmount)
//         let rect:CGRect = rect.inset(by: inset)
//         return CGShapeUtil.drawRect(shapeLayer:.init(),rect:rect, style:(nil,.white,length))
//      }()
//      return (blackShape, whiteShape)
//   }
}
