import AVFoundation
import QuartzCore
import CoreImage
/**
 * Reads camera input
 * - Note: also supports reading generated mock CVBuffere image
 * - Abstract: Converts image, to rgb and SambleBuffer to RGB
 * - Note: Ref context for macOS might need: https://stackoverflow.com/a/43893381/5389500
 */
public final class BufferUtil {}

extension BufferUtil {
   /**
    * CVImageBuffer -> RGBImage (⭐ works ⭐)
    * 1. CVImageBuffer comes in with areaOfIntrest crop
    * 2. Raw data and size is extracted from imageBuffer
    * 3. Raw data is converted into Array of Pixel's
    * 4. Pixel's are added to RGBAImage an is then returned
    * - Note: CVPixelBuffer is a typalias for CVImageBuffer
    * - Note: CVPixelBufferRelease' is unavailable: Core Foundation objects are automatically memory managed
    * - Fixme: ⚠️️ Might have the solution for av buffer: https://stackoverflow.com/questions/29375471/how-to-convert-cvimagebuffer-to-uiimage
    * - Fixme: ⚠️️ Using a pointer to iterate might be faster, see stackoverflow
    * - Fixme: ⚠️️ Add debug tool with: CVPixelBufferGetDataSize(imageBuffer), \(CVPixelBufferGetDataSize(imageBuffer)) type:  \(CVPixelBufferGetPixelFormatType(imageBuffer)), let info = RGBImage.bitmapInfo(buffer: imageBuffer)// if type != kCVPixelFormatType_DepthFloat32 { print("Wrong type \(type)"); throw NSError(domain: "Wrong type", code: 0) }, let type: OSType = CVPixelBufferGetPixelFormatType(imageBuffer) // Swift.print("type:  \(type)")
    * - Fixme: ⚠️️ These methods might be faster: https://github.com/frogcjn/ImageIOPlus/blob/1d401725a3f7cd87b000a085eaca65e2cd0c0446/Sources/CoreVideoPlus/CVPixelBuffer/CVPixelBuffer%2B.swift
    * - Important: ⚠️️ doing concurrent on the loop has minimal effect, doing it on the call to this method has alot of effect
    * - Parameters:
    *   - buffer: the buffer containing the raw pixel data and size
    *   - crop: Makes processing the raw imagery faster since we don't have to process areas where the QR info is not etc. (provided we know where the QR rect is)
    */
   public static func rgbaRep(buffer: CVImageBuffer, crop bufferRect: BufferRect) throws -> RGBARep { /*, size: CGSize, scale: CGFloat */
      CVPixelBufferLockBaseAddress(buffer, CVPixelBufferLockFlags(rawValue: CVOptionFlags(0))) // lock access for cpu reading
      let bytesPerPixel: Int = CVPixelBufferGetBytesPerRow(buffer) // let bufferSize: (width: Int, height: Int) = (Int(CVPixelBufferGetWidth(imageBuffer)), Int(CVPixelBufferGetHeight(imageBuffer))) //  let size: (width: Int, height: Int) = (Int(size.width * scale), Int(size.height * scale))
      guard let baseAddress: UnsafeMutableRawPointer = CVPixelBufferGetBaseAddress(buffer) else { throw NSError(domain: "Unable to get baseAddress", code: 0) }
      // - Fixme: ⚠️️ This is prob a bug, you should only lock once
      // CVPixelBufferLockBaseAddress(imageBuffer, CVPixelBufferLockFlags(rawValue: 0))
      let byteBuffer: UnsafeMutablePointer<UInt8> = baseAddress.assumingMemoryBound(to: UInt8.self)
//      defer { byteBuffer.deallocate() } // new ⚠️️ doesnt work
      let capacity: Int = bufferRect.width * bufferRect.height
      let pixels: UnsafeMutablePointer<Pixel> = .allocate(capacity: capacity) // we dealoc this when we have finished working with rgbaRep
      (bufferRect.y..<bufferRect.height).forEach { y in
         let yVal: Int = y * bytesPerPixel // we calc these outside the x loop, to gain performance
         let yAndWidth: Int = y * bufferRect.width // we calc these outside the x loop, to gain performance
         (bufferRect.x..<bufferRect.width).forEach { x in
            let index: Int = x * 4 + yVal // We add the crop to the x // (y * bytesPerPixel + x) * 4
            // ⚠️️ new, was byteBuffer[index] etc
            let (b, g, r) = (byteBuffer.advanced(by: index).pointee, byteBuffer.advanced(by: index + 1).pointee, byteBuffer.advanced(by: index + 2).pointee) // let a = byteBuffer[index + 3]
            let pixel: Pixel = .init(r: r, g: g, b: b/*, a: 255*/)
            let i: Int = yAndWidth + x
            pixels[i] = pixel
         }
      }
      defer { CVPixelBufferUnlockBaseAddress(buffer, CVPixelBufferLockFlags(rawValue: CVOptionFlags(0))) } // release access for cpu reading 
      // - Fixme: ⚠️️ might want to wrap all this in autoreleasepool as well, or is tha tmore for just cgimage?
      return .init(pixels: pixels, width: bufferRect.width, height: bufferRect.height)
   }
}
