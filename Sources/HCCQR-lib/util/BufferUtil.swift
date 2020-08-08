import AVFoundation
import QuartzCore
import CoreImage
/**
 * Reads camera input
 * - Note: also supports reading generated mock CVBuffere image
 * - Abstract: Converts image, to rgb and SambleBuffer to RGB
 * - Note: Ref context for macOS might need: https://stackoverflow.com/a/43893381/5389500
 * - Fixme: ⚠️️ rename to BufferHelper?
 */
public final class BufferUtil {}

extension BufferUtil {
   /**
    * Image -> RGBAImage (Not working)
    * - Note: this method works when testing img -> RGBA img -> img in viewcontroll, to see if everything looks gd etc, or do img.hash = img.hash etc
    * - Note: this method is for testing only because we derive RGBAImage directly from CVImageBuffer
    * - Note: RGBARep.rgbaRep(image:) has similar functionality
    * - Parameter image: Convert image to RGBAImage
    */
   public static func rgbRep(image: Image) throws -> RGBRep {
      let imgBuffer: CVImageBuffer = try imageBuffer(image: image)
      return try rgbRep(buffer: imgBuffer, crop: imgBuffer.rect) // Rect -> We have to provide the area we want to get data from /*, size: image.size, scale: image.scale*/
   }
   /**
    * CVImageBuffer -> RGBImage (⭐ works ⭐)
    * 1. CVImageBuffer comes in with areaOfIntrest crop
    * 2. Raw data and size is extracted from imageBuffer
    * 3. Raw data is converted into Array of Pixel's
    * 4. Pixel's are added to RGBAImage an is then returned
    * - Note: We dont dealloc the byteBuffer etc because its backed by the cvimagebuff
    * - Note: CVPixelBuffer is a typalias for CVImageBuffer
    * - Note: CVPixelBufferRelease' is unavailable: Core Foundation objects are automatically memory managed
    * - Fixme: ⚠️️ Might have the solution for av buffer: https://stackoverflow.com/questions/29375471/how-to-convert-cvimagebuffer-to-uiimage
    * - Fixme: ⚠️️ Using a pointer to iterate might be faster, see stackoverflow
    * - Fixme: ⚠️️ Add debug tool with: CVPixelBufferGetDataSize(imageBuffer), \(CVPixelBufferGetDataSize(imageBuffer)) type:  \(CVPixelBufferGetPixelFormatType(imageBuffer)), let info = RGBImage.bitmapInfo(buffer: imageBuffer)// if type != kCVPixelFormatType_DepthFloat32 { print("Wrong type \(type)"); throw NSError(domain: "Wrong type", code: 0) }, let type: OSType = CVPixelBufferGetPixelFormatType(imageBuffer) // Swift.print("type:  \(type)")
    * - Fixme: ⚠️️ These methods might be faster: https://github.com/frogcjn/ImageIOPlus/blob/1d401725a3f7cd87b000a085eaca65e2cd0c0446/Sources/CoreVideoPlus/CVPixelBuffer/CVPixelBuffer%2B.swift
    * - Fixme: ⚠️️ consider accelerate framework instead, see: https://developer.apple.com/documentation/accelerate/1498254-vimageconverter_createforcvtocgi
    * - Fixme: ⚠️️ benchmark how fast this method is
    * - Fixme: ⚠️️ might want to wrap all this in autoreleasepool as well, or is tha tmore for just cgimage?
    * - Fixme: ⚠️️ could possibly see great speed increase if we align indecies, and do modulo to find width and y and x etc
    * - Important: ⚠️️ doing concurrent on the loop has minimal effect, doing it on the call to this method has alot of effect
    * - Parameters:
    *   - buffer: the buffer containing the raw pixel data and size
    *   - crop: Makes processing the raw imagery faster since we don't have to process areas where the QR info is not etc. (provided we know where the QR rect is)
    */
   public static func rgbRep(buffer: CVImageBuffer, crop bufferRect: BufferRect) throws -> RGBRep { /*, size: CGSize, scale: CGFloat */
      CVPixelBufferLockBaseAddress(buffer, CVPixelBufferLockFlags(rawValue: CVOptionFlags(0))) // lock access for cpu reading
      let bytesPerRow: Int = CVPixelBufferGetBytesPerRow(buffer) // let bufferSize: (width: Int, height: Int) = (Int(CVPixelBufferGetWidth(imageBuffer)), Int(CVPixelBufferGetHeight(imageBuffer))) //  let size: (width: Int, height: Int) = (Int(size.width * scale), Int(size.height * scale))
      guard let baseAddress: UnsafeMutableRawPointer = CVPixelBufferGetBaseAddress(buffer) else { throw NSError(domain: "Unable to get baseAddress", code: 0) }
      // - Fixme: ⚠️️ This is prob a bug, you should only lock once
      // CVPixelBufferLockBaseAddress(imageBuffer, CVPixelBufferLockFlags(rawValue: 0))
      let capacity: Int = bufferRect.size.capacity
      let byteBuffer: UnsafeBufferPointer<UInt8> = .init(start: baseAddress.bindMemory(to: UInt8.self, capacity: capacity), count: capacity)// baseAddress.assumingMemoryBound(to: UInt8.self)// .init()
      let pixels: UnsafeMutableBufferPointer<Pixel> = .allocate(capacity: capacity) // we dealoc this when we have finished working with rgbaRep
      let bytesPerPixel: Int = MemoryLayout<RGBAPixel>.size
      (bufferRect.y..<bufferRect.height).forEach { y in
         let yVal: Int = y * bytesPerRow // we calc these outside the x loop, to gain performance
         let yAndWidth: Int = y * bufferRect.width // we calc these outside the x loop, to gain performance
         (bufferRect.x..<bufferRect.width).forEach { x in
            let index: Int = x * bytesPerPixel + yVal // We add the crop to the x // (y * bytesPerPixel + x) * 4
            let pixel: Pixel = .init(r: byteBuffer[index + 2], g: byteBuffer[index + 1], b: byteBuffer[index + 0])
            let i: Int = yAndWidth + x
            pixels[i] = pixel
         }
      }
      defer { CVPixelBufferUnlockBaseAddress(buffer, CVPixelBufferLockFlags(rawValue: CVOptionFlags(0))) } // release access for cpu reading
      return .init(pixels: .init(pixels), width: bufferRect.width, height: bufferRect.height)
   }
}
/**
 * Buffer
 */
extension BufferUtil {
   /**
    * UIImage -> CVPixelBuffer
    * - Fixme: ⚠️️ add step doc
    * - Fixme: ⚠️️ Use Metal: https://developer.apple.com/documentation/coreimage/cicontext/1437609-init
    * - Note: Ref https://www.hackingwithswift.com/whats-new-in-ios-11 and https://stackoverflow.com/a/44475334/5389500
    * - Note: Alternative https://gist.github.com/omarojo/b47ad0f0965ba8bf2e825ef571ef804c
    * - Note: CGImage to Buffer https://github.com/brianadvent/UIImage-to-CVPixelBuffer/blob/master/ImageProcessor.swift
    * - Note: ref https://stackoverflow.com/questions/3838696/convert-uiimage-to-cvpixelbufferref
    * - Note: ref https://stackoverflow.com/questions/44462087/how-to-convert-a-uiimage-to-a-cvpixelbuffer
    * - Note: this is for debugging, if it wasnt, we could optimize by using a CVPixelPool
    * - Parameter image: Convert this image to CVImageBuffer
    * - Fixme: ⚠️️ rename to buffer?
    */
   public static func imageBuffer(image: Image) throws -> CVImageBuffer {
      guard let cgImage = image.cgImage() else { throw NSError(domain: "unable to get cgimage", code: 0) }
      return try imageBuffer(cgImage: cgImage)
   }
   /**
    * CGImage -> CVPixelBuffer
    * - Note: Ref https://github.com/brianadvent/UIImage-to-CVPixelBuffer/blob/master/ImageProcessor.swift
    * - Important: ⚠️️ This methd exists for testing purpouses, the real code derives the buffer directly
    * - Fixme: ⚠️️ Make debug tool for cgImage: cgImage.bitsPerPixel, cgImage.bitsPerComponent, cgImage.colorSpace, cgImage.byteOrderInfo, cgImage.bitmapInfo, image.size, image.scale, image.cgImage?.bytesPerRow
    * - Parameters:
    *   - cgImage: The cgImage to be converted to CVImageBuffer
    *   - opaque: opaque, aka no alpha
    * - Fixme: ⚠️️ can probably use different combo of buffer rgba, bgra alpha info 32litte etc. figure out what is fastest n the future etc
    * - Fixme: ⚠️️ we dont need opaque param, thats only for png, cam-output, jpg doesnt have alpha.
    * - Fixme: ⚠️️ rename to buffer
    * - Fixme: ⚠️️ benchmark this, consider accelerate framework instead see: https://developer.apple.com/documentation/accelerate/1498241-vimageconverter_createforcgtocvi   and https://developer.apple.com/documentation/accelerate/building_a_basic_conversion_workflow
    */
   public static func imageBuffer(cgImage: CGImage, opaque: Bool = true) throws -> CVImageBuffer {
      let frameSize = CGSize(width: cgImage.width, height: cgImage.height)
      var _buffer: CVPixelBuffer?
      let pixelFormatType: OSType = kCVPixelFormatType_32BGRA // kCVPixelFormatType_24RGB, kCVPixelFormatType_24BGR
      let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(frameSize.width), Int(frameSize.height), pixelFormatType, nil, &_buffer)
      guard let buffer: CVPixelBuffer = _buffer else { throw BufferError.unableToCreateBuffer }
      if status != kCVReturnSuccess { throw BufferError.statusError }
      CVPixelBufferLockBaseAddress(buffer, CVPixelBufferLockFlags(rawValue: 0))
      let data = CVPixelBufferGetBaseAddress(buffer)
      let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
      let bitmapInfo = CGBitmapInfo(rawValue: CGBitmapInfo.byteOrder32Little.rawValue | CGImageAlphaInfo.premultipliedFirst.rawValue)
      guard let context = CGContext(data: data, width: Int(frameSize.width), height: Int(frameSize.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(buffer), space: rgbColorSpace, bitmapInfo: bitmapInfo.rawValue) else { throw BufferError.unableToGetContext }
      let rect: CGRect = .init(x: 0, y: 0, width: cgImage.width, height: cgImage.height)
      context.draw(cgImage, in: rect)
      // - Fixme: ⚠️️ Should we unlock buffer here, since we return it etc ?, other repos lock here and still forward buffer
      CVPixelBufferUnlockBaseAddress(buffer, CVPixelBufferLockFlags(rawValue: 0))
      return buffer
   }
}
/**
 * Image (debug only)
 */
extension BufferUtil {
   /**
    * CVImageBuffer -> UIImage
    * - Important: ⚠️️ This methd exists for testing/debugging purpouses, the real code derives the buffer directly
    * - Parameters:
    *   - imageBuffer: Convert buffer to image
    *   - scale: the amount to scale the image by (screenScale)
    */
   public static func image(imageBuffer: CVImageBuffer, scale: Int) -> Image {
      let ciImage: CIImage = .init(cvImageBuffer: imageBuffer)
      return ImageUtil.image(ciImage: ciImage, scale: CGFloat(scale))
   }
}

/**
 * Error
 */
extension BufferUtil {
   /**
    * Rename to CIImgBufferError
    */
   public enum BufferError: Error {
      case unableToCreateBuffer
      case statusError
      case unableToGetContext
   }
}
