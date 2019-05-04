import UIKit
@testable import HCCQR_lib_iOS
/**
 * Debug
 */
extension AlignMarkUtil {
   /**
    * Debug marks
    */
   static func drawDebugSquare(metric: AlignBox, pos: CGPoint) -> (CAShapeLayer, CAShapeLayer) {
      let rect: CGRect = .init(x: pos.x, y: pos.y, width: metric.totalLength, height: metric.totalLength)
      /*Outer stroked-square*/
      let outerShape: CAShapeLayer = {
         /*adds margin*/
         let insetAmount: CGFloat = metric.outerLength //+ (metric.innerLength/2)
         let inset: UIEdgeInsets = .init(top: insetAmount, left: insetAmount, bottom: insetAmount, right: insetAmount)
         let outerRect: CGRect = rect.inset(by: inset)
         return CGShapeUtil.drawRect(shapeLayer: .init(), rect: outerRect, style: (UIColor.red.withAlphaComponent(0.5), nil, nil))
      }()
      /*Inner square*/
      let innerShape: CAShapeLayer = {
         let insetAmount: CGFloat = metric.outerLength + metric.outerLength + (metric.innerLength)
         let inset: UIEdgeInsets = .init(top: insetAmount, left: insetAmount, bottom: insetAmount, right: insetAmount)
         let innerRect: CGRect = rect.inset(by: inset)
         let blackShape = CGShapeUtil.drawRect(shapeLayer: .init(), rect: innerRect, style: (UIColor.yellow.withAlphaComponent(0.5), nil, nil))
         return blackShape
      }()
      return (outerShape, innerShape)
   }
}
