import AVFoundation
import QuartzCore
import CoreImage

extension CVImageBufferUtil {
   /**
    * Image -> RGBAImage (Not working)
    * - Fixme: ⚠️️ Add Image typealias in this repo
    */
   public static func rgbaImage(image: Image) throws -> RGBAImage {
      let imgBuffer: CVImageBuffer = try imageBuffer(image: image)
      return try rgbaImage(imageBuffer: imgBuffer) /*, size: image.size, scale: image.scale*/
   }
   /**
    * CVImageBuffer -> RGBImage (⭐ works ⭐)
    * - Note: CVPixelBuffer is a typalias for CVImageBuffer
    * - Note: CVPixelBufferRelease' is unavailable: Core Foundation objects are automatically memory managed
    * - Fixme: ⚠️️ might have the solution for av buffer: https://stackoverflow.com/questions/29375471/how-to-convert-cvimagebuffer-to-uiimage
    * - Fixme: ⚠️️ using a pointer to iterate might be faster, see stackoverflow
    * - Fixme: ⚠️️ striding with 20 might be faster than nested for loop
    * - add debug tool with: CVPixelBufferGetDataSize(imageBuffer), \(CVPixelBufferGetDataSize(imageBuffer)) type:  \(CVPixelBufferGetPixelFormatType(imageBuffer)), let info = RGBImage.bitmapInfo(buffer: imageBuffer)// if type != kCVPixelFormatType_DepthFloat32 { print("Wrong type \(type)"); throw NSError(domain: "Wrong type", code: 0) }, let type: OSType = CVPixelBufferGetPixelFormatType(imageBuffer) // Swift.print("type:  \(type)")
    */
   public static func rgbaImage(imageBuffer: CVImageBuffer) throws -> RGBAImage { /*, size: CGSize, scale: CGFloat */
      CVPixelBufferLockBaseAddress(imageBuffer, CVPixelBufferLockFlags(rawValue: CVOptionFlags(0))) // lock access for cpu reading
      let bufferSize: (width: Int, height: Int) = (Int(CVPixelBufferGetWidth(imageBuffer)), Int(CVPixelBufferGetHeight(imageBuffer))) //  let size: (width: Int, height: Int) = (Int(size.width * scale), Int(size.height * scale))
      //Swift.print("bufferSize:  \(bufferSize)")
      let bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer)
      guard let baseAddress: UnsafeMutableRawPointer = CVPixelBufferGetBaseAddress(imageBuffer) else { throw NSError(domain: "Unable to get baseAddress", code: 0) }
      //- Fixme: ⚠️️ this is prob a bug, you should only lock once
      //CVPixelBufferLockBaseAddress(imageBuffer, CVPixelBufferLockFlags(rawValue: 0))
      let byteBuffer = baseAddress.assumingMemoryBound(to: UInt8.self)
      let capacity: Int = bufferSize.width * bufferSize.height
      let pixels = UnsafeMutableBufferPointer<PixelData>.allocate(capacity: capacity)
      let bytesPerPixel = bytesPerRow
      for y in 0..<bufferSize.height {
         DispatchQueue.concurrentPerform(iterations: bufferSize.width) { x in // ⚠️️ Optimization initiative, might be faster, also try striding?
            let index = x * 4 + y * bytesPerPixel // (y * bytesPerPixel + x) * 4
            let b = byteBuffer[index]
            let g = byteBuffer[index + 1]
            let r = byteBuffer[index + 2]
            //let a = byteBuffer[index + 3]
            let pixel: PixelData = .init(r: r, g: g, b: b, a: 255) // Swift.print("r:  \(r) g:  \(g) b:  \(b) a: \(a)")
            let i: Int = y * bufferSize.width + x
            pixels[i] = pixel
         }
      }
      let rgbaImage: RGBAImage = .init(pixels: pixels, width: bufferSize.width, height: bufferSize.height)
      CVPixelBufferUnlockBaseAddress(imageBuffer, CVPixelBufferLockFlags(rawValue: CVOptionFlags(0))) // release access for cpu reading
      // - Fixme: ⚠️️ might want to wrap all this in autoreleasepool as well
      return rgbaImage
   }
}
