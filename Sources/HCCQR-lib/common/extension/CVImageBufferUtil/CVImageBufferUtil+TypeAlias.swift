import Foundation
import AVFoundation
import QuartzCore
import CoreImage
// extension CVImageBufferUtil {}
/**
 * - Note: We can't use CGRect, as we need Int values
 * - Fixme: ⚠️️ Possibly use UInt32 etc in the future
 */
public typealias BufferRect = (x: Int, y: Int, width: Int, height: Int)
/**
 * Returns the Rect of the Buffer, so that it can work with the cropping functionality
 * - Note this method is global, so that other class scopes can also use this functionality
 */
func CVImageBufferGetDisplayRect(imageBuffer: CVImageBuffer) -> BufferRect {
   let size: CGSize = CVImageBufferGetDisplaySize(imageBuffer)
   let point: CGPoint = .zero
   return (width: Int(size.width), height: Int(size.height), x: Int(point.x), y: Int(point.y))
}
