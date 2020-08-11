import Foundation
import AVFoundation
import QuartzCore
import CoreImage

extension CVImageBuffer {
   /**
    * Returns the Rect of the Buffer, so that it can work with the cropping functionality
    * - Note: ⚠️️ this method was global, so that other class scopes can also use this functionality (Similar to how other Native Buffer methods work)
    * - Note: Self is the buffer containing the raw pixel data and size
    * - Note: there are also: CVImageBufferGetDisplaySize, CVImageBufferGetCleanRect
    */
   public var rect: BufferRect {
      let size: CGSize = CVImageBufferGetDisplaySize(self)
      return .init(0, 0, Int(size.width), Int(size.height))
   }
}
