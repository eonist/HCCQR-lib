import UIKit
import QR_lib
//@testable import HCCQR_lib_iOS
//AimImg = View.snapshot
//Result = Composit(HccqrIMG,aimImg
//
//When u separate, you need to remove the pixels you take away, and overrite these areas.
//Or
//Grab all blackidh colors and Add them to final QR img. So u Get the aim boxes.
//You could also Draw aim stuff in say yellow. 🤷
//you can make black stuff black inside the qrSquareBoundingBox 👌


class AlignMarkUtil {
   /**
    * Creates an UIIMageView with the Align marks drawn into the image
    * ## Examples:
    * AlignMarkUtil.alignMarkGraphic(qrImgSize: image.size, strCount: string.count)
    * - Fixme: ⚠️️ add support for secondary align marks
    */
   static func alignMarkGraphic(qrImgSize: CGSize, string: String, ecLevel: ECLevel) -> UIImageView? {
//      Swift.print("alignMarkGraphic.strCount:  \(strCount)")
//      let metric:AlignBoxMetric = {
//         let (small,medium,big) = (AlignMarkUtil.small.charRange,AlignMarkUtil.medium.charRange,AlignMarkUtil.big.charRange)
//         if strCount >= small.start && strCount < small.end {
////            Swift.print("small")
//            return AlignMarkUtil.small.metric
//         }else if  strCount >= medium.start && strCount < medium.end {
////            Swift.print("medium")
//            return AlignMarkUtil.medium.metric
//         }else if  strCount >= big.start && strCount <= big.end {
////            Swift.print("big")
//            return AlignMarkUtil.big.metric
//         }else {
//            Swift.print("type not supported")
//            return AlignMarkUtil.big.metric
//         }
//      }()
      guard let alignBox: AlignBox = AlignMarkUtil.alignBox(string: string, ecLevel: ecLevel, side: qrImgSize.width) else { Swift.print("unable to create alignbox"); return nil }
      let viewRect: CGRect = .init(origin: .zero, size: qrImgSize)
      let view: UIView = drawSquares(view: .init(frame: viewRect), qrImgSize: qrImgSize, metric: alignBox)
      let img: UIImage? = view.snapShot//create an image of the view
      let imageView: UIImageView = .init(image:img)
      return imageView
   }
}
/**
 * Helper
 */
extension AlignMarkUtil {
   /**
    * Draw align marks
    * - Note: Primary points is used as position detection pattern (so that the qr-code can be read from any direction)
    * - NOTE: Secondary points are The alignment pattern is used for position detection when there is displacement of modules due to distortion. It is applied to model 2.
    */
   fileprivate static func drawSquares(view: UIView, qrImgSize: CGSize, metric: AlignBox) -> UIView {
      let primaryPoints: [CGPoint] = {
         let tl = AlignMarkUtil.topLeft()
         let tr = AlignMarkUtil.topRight(qrImgSize: qrImgSize, markLength: metric.squareLength)
         let bl = AlignMarkUtil.bottomLeft(qrImgSize: qrImgSize, markLength: metric.squareLength)
         return [tl, tr, bl]
      }()
      /*Draw the shapeLayers into the view*/
      primaryPoints.forEach {
         let square = drawDebugSquare(metric: metric, pos: $0)//drawSquare
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
