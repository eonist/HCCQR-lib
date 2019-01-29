import UIKit
/**
 * Metrics
 * - TODO: ⚠️️ Remove length, its always 6x the thickness 👌
 */
extension AlignMarkUtil {
   typealias CharRange = (start:Int, end:Int)
   typealias AlignBoxMetric = (outerLength:CGFloat,innerLength:CGFloat, squareLength:CGFloat)
   typealias AlignBoxType = (charRange:CharRange, metric:AlignBoxMetric)
   static let small:AlignBoxType = (charRange:(0,100),metric:(16,16,44))
   static let medium:AlignBoxType = (charRange:(100,200),metric:(16,16,44))
   static let big:AlignBoxType = (charRange:(200,300),metric:(6,7,(6*6+7*3)))
   static let alignBoxSizes:[AlignBoxType] = [small,medium,big]
}
/**
 * Metrics
 */
extension AlignMarkUtil {
   static func topLeft() -> CGPoint {
      return .init(x:0,y:0)
   }
   static func topRight(qrImgSize:CGSize, markLength:CGFloat) -> CGPoint {
      return .init(x:qrImgSize.width - markLength , y:0)
   }
   static func bottomLeft(qrImgSize:CGSize, markLength:CGFloat) -> CGPoint {
      return .init(x:0, y:qrImgSize.height - markLength )
   }
}
