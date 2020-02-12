import AVFoundation
import QuartzCore
import CoreImage

extension CVImageBufferUtil {
   /**
    * CVImageBuffer -> RGBImage (⭐ works ⭐)
    * - Note: CVPixelBuffer is a typalias for CVImageBuffer
    * - Note: CVPixelBufferRelease' is unavailable: Core Foundation objects are automatically memory managed
    * - Fixme: ⚠️️ Might have the solution for av buffer: https://stackoverflow.com/questions/29375471/how-to-convert-cvimagebuffer-to-uiimage
    * - Fixme: ⚠️️ Using a pointer to iterate might be faster, see stackoverflow
    * - Fixme: ⚠️️ Striding with 20 might be faster than nested for loop, experiment with this
    * - Fixme: ⚠️️ Add debug tool with: CVPixelBufferGetDataSize(imageBuffer), \(CVPixelBufferGetDataSize(imageBuffer)) type:  \(CVPixelBufferGetPixelFormatType(imageBuffer)), let info = RGBImage.bitmapInfo(buffer: imageBuffer)// if type != kCVPixelFormatType_DepthFloat32 { print("Wrong type \(type)"); throw NSError(domain: "Wrong type", code: 0) }, let type: OSType = CVPixelBufferGetPixelFormatType(imageBuffer) // Swift.print("type:  \(type)")
    * - Parameters:
    *   - imageBuffer: the buffer containing the raw pixel data and size
    *   - crop: Makes processing the raw imagery faster since we don't have to process areas where the QR info is not etc.
    */
   public static func rgbaImage(imageBuffer: CVImageBuffer, crop bufferRect: BufferRect) throws -> RGBAImage { /*, size: CGSize, scale: CGFloat */
      CVPixelBufferLockBaseAddress(imageBuffer, CVPixelBufferLockFlags(rawValue: CVOptionFlags(0))) // lock access for cpu reading
      // let bufferSize: (width: Int, height: Int) = (Int(CVPixelBufferGetWidth(imageBuffer)), Int(CVPixelBufferGetHeight(imageBuffer))) //  let size: (width: Int, height: Int) = (Int(size.width * scale), Int(size.height * scale))
      // Swift.print("bufferSize:  \(bufferSize)")
      let bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer)
      guard let baseAddress: UnsafeMutableRawPointer = CVPixelBufferGetBaseAddress(imageBuffer) else { throw NSError(domain: "Unable to get baseAddress", code: 0) }
      // - Fixme: ⚠️️ This is prob a bug, you should only lock once
      // CVPixelBufferLockBaseAddress(imageBuffer, CVPixelBufferLockFlags(rawValue: 0))
      let byteBuffer: UnsafeMutablePointer<UInt8> = baseAddress.assumingMemoryBound(to: UInt8.self)
      let capacity: Int = bufferRect.width * bufferRect.height
      let pixels = UnsafeMutableBufferPointer<PixelData>.allocate(capacity: capacity)
      let bytesPerPixel = bytesPerRow
      for y in bufferRect.y..<bufferRect.height {
         DispatchQueue.concurrentPerform(iterations: bufferRect.width) { x in // ⚠️️ Optimization initiative, might be faster, also try striding?
            let index = (bufferRect.x + x) * 4 + y * bytesPerPixel // we add the crop to the x // (y * bytesPerPixel + x) * 4
            let b = byteBuffer[index]
            let g = byteBuffer[index + 1]
            let r = byteBuffer[index + 2]
            //let a = byteBuffer[index + 3]
            let pixel: PixelData = .init(r: r, g: g, b: b, a: 255) // Swift.print("r:  \(r) g:  \(g) b:  \(b) a: \(a)")
            let i: Int = y * bufferRect.width + x
            pixels[i] = pixel
         }
      }
      let rgbaImage: RGBAImage = .init(pixels: pixels, width: bufferRect.width, height: bufferRect.height)
      CVPixelBufferUnlockBaseAddress(imageBuffer, CVPixelBufferLockFlags(rawValue: CVOptionFlags(0))) // release access for cpu reading
      // - Fixme: ⚠️️ might want to wrap all this in autoreleasepool as well
      return rgbaImage
   }
}
/**
 * For testing only (May be deprecated soon)
 */
extension CVImageBufferUtil {
   /**
    * Image -> RGBAImage (Not working)
    * - Fixme: ⚠️️ Add Image typealias in this repo
    * - Important: ⚠️️ this method is for testing only because we derive RGBAImage directly from CVImageBuffer
    * - Parameter image: Convert image to RGBAImage
    */
   public static func rgbaImage(image: Image) throws -> RGBAImage {
      let imgBuffer: CVImageBuffer = try imageBuffer(image: image)
      let bufferRect: BufferRect = CVImageBufferGetDisplayRect(imageBuffer: imgBuffer) // We have to provide the area we want to get data from
      return try rgbaImage(imageBuffer: imgBuffer, crop: bufferRect) /*, size: image.size, scale: image.scale*/
   }
}
