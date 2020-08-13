import Foundation
import CoreImage

extension RGBRep {
   /**
    * Converts an Image to an rgbImage
    * - Description: RGBImage holds the individual pixels of an image in an array (also stores the size of an image)
    * - Fixme: ⚠️️ instead of trying to convert to cgImage, you can actually use ciImage or cgImage contexts, an image will have either, and both will render to CGCOntext, no need to convert to a new cgImage or CIImage etc, see rgbaRepresentation for more info
    * - Note: For testing and for use in the video file module
    * - Fixme: ⚠️️ we could try the ByteImage ciImage or cgImage technique
    * - Note: this init is fast. trying other ways to get pixel could have some usefulness, but shouldn't be prioritized 0.016330782sec for v30 image
    * - Note: the CVImageBufferUtil.rgbRep has similar functionality (Biffer -< RGBARep)
    * - Parameter image: An UIImage or NSImage
    */
   internal init(image: Image) throws {
      guard let cgImage: CGImage = ImageUtil.cgImage(image: image) else { Swift.print("cg"); throw NSError(domain: "rgbaImage - Unable to get cgImage", code: 0) }
      try self.init(cgImage: cgImage)
   }
}
/**
 * Private
 */
extension RGBRep {
   /**
    * CGImage -> RGBImage
    * - Note: Used by Image -> RGBRep
    *  - Fixme: ⚠️️ try withMemoryRebound instead of the while loop
    */
   internal init(cgImage: CGImage) throws {
      let size: BufferSize = .init(Int(cgImage.width), Int(cgImage.height))
      let bytesPerPixel = MemoryLayout<RGBAPixel>.size
      let bytesPerRow: Int = size.width * bytesPerPixel // We multiply per 4 because of the 4 channels, RGBA
      let capacity: Int = size.capacity
      let imageData: UnsafeMutablePointer<RGBAPixel> = .allocate(capacity: capacity)
      let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceRGB()
      let bitMapInfo = BitmapInfo.bitmapInfo
      guard let cgContext = CGContext(data: imageData, width: size.width, height: size.height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitMapInfo) else { Swift.print("context"); throw NSError(domain: "rgbImage - Unable to create rgbImage", code: 0) }
      cgContext.draw(cgImage, in: .init(origin: .zero, size: .init(width: cgImage.width, height: cgImage.height))) // draws the cgImage into the context
      let pixis: UnsafeMutableBufferPointer<Pixel> =  .allocate(capacity: capacity)
      var i: Int = 0
      while i < capacity {
         pixis[i] = imageData.advanced(by: i).pointee.pixel
         i = i &+ 1 // &+ is used to obtain a little performance gain
      }
      imageData.deallocate() // We have no more use for imageData
      self.init(pixels: .init(pixis), width: size.width, height: size.height)
   }
}
/**
 * Deallocates pixels
 */
extension RGBRep {
   func deallocate() {
      pixels.deallocate()
   }
}
