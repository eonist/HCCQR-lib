import UIKit
import QRLibIOS
/**
 * Metrics
 * - TODO: ⚠️️ Remove length, its always 6x the thickness 👌
 */
extension AlignMarkUtil {
   /**
    * - Parameter marginLength: 4 modules (The margin is a blank area around the QR code. Model 1...40 require a margin of four modules and Micro QR code requires of two modules.)
    * - Parameter outerLength: 2 modules (the black margin outside the white void)
    * - Parameter innerLenth: 2 modules (the white margin outside the middle the black square)
    * - Parameter squareLength: 3 modules (the black square  in the middle)
    */
   enum PrimaryAimMark {
      fileprivate static let totalLength:Int = 9//marginLength + outerLength + innerLength + squareLength + innerLength + outerLength + marginLength//Total length of the AimMark
      fileprivate static let marginLength:Int = 1//aka QRMargin
      fileprivate static let outerLength:Int = 1
      fileprivate static let innerLength:Int = 1
      fileprivate static let squareLength:Int = 3
   }
   
   //Continue here: 🏀
      //moduleCount, does not include margin
      //count the amount in the render, use these numbers, not the nums from the web
   
   
   typealias AlignBox = (marginLength:CGFloat,outerLength:CGFloat,innerLength:CGFloat, squareLength:CGFloat, totalLength:CGFloat)
   /**
    * - Parameter side: a side of qrBoxSize
    */
   static func alignBox(string:String, ecLevel:ECLevel, side:CGFloat) -> AlignBox?{
      let ecLevel:ECLevel = .l
      guard let moduleCount:Int = QRInfoUtil.moduleCount(string: string, ecLevel:ecLevel) else {Swift.print("⚠️️ unable to get moduleCount ⚠️️");return nil}
      Swift.print("moduleCount:  \(moduleCount)")
      /*Figure out how many pixels a module consist of*/
      let pixelsPerModule:CGFloat = side / CGFloat(moduleCount)
      Swift.print("pixelsPerModule:  \(pixelsPerModule)")
      let marginLength:CGFloat = pixelsPerModule * CGFloat(PrimaryAimMark.marginLength)
      let outerLength:CGFloat = pixelsPerModule * CGFloat(PrimaryAimMark.outerLength)
      let innerLength:CGFloat = pixelsPerModule * CGFloat(PrimaryAimMark.innerLength)
      let squareLength:CGFloat = pixelsPerModule * CGFloat(PrimaryAimMark.squareLength)
      let totalLength:CGFloat = pixelsPerModule * CGFloat(PrimaryAimMark.totalLength)
      return (marginLength,outerLength,innerLength,squareLength,totalLength)
   }
   
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


extension AlignMarkUtil{
   /*DEPRECATED*/
   typealias CharRange = (start:Int, end:Int)
   typealias AlignBoxMetric = (outerLength:CGFloat,innerLength:CGFloat, squareLength:CGFloat)
   typealias AlignBoxType = (charRange:CharRange, metric:AlignBoxMetric)
   static let small:AlignBoxType = (charRange:(0,100),metric:(16,16,44))
   static let medium:AlignBoxType = (charRange:(100,200),metric:(16,16,44))
   static let big:AlignBoxType = (charRange:(200,300),metric:(6,7,(6*6+7*3)))
   static let alignBoxSizes:[AlignBoxType] = [small,medium,big]
   /*DEPRECATED*/
}
