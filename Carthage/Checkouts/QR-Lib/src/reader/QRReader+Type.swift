import Foundation
/**
 * Type
 */
extension QRReader{
   public typealias DataAndFeature = (qrData: Data, feature: CIQRCodeFeature)
   public typealias DataAndFrame = (qrData: Data, qrFrame: CGRect)
   public typealias Quad = (p1:CGPoint,p2:CGPoint,p3:CGPoint,p4:CGPoint)
   public typealias DataAndQuad = (qrData: Data, quad:Quad )
}
