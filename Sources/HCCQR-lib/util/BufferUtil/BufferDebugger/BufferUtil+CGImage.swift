import AVFoundation
import QuartzCore
import CoreImage

extension BufferUtil {
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
