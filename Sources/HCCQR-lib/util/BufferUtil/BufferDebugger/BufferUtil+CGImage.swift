import AVFoundation
import QuartzCore
import CoreImage

extension BufferUtil {
   /**
    * Rename to CIImgBufferError
    */
   public enum ImgBufferError: Error {
      case statusError
      case unableToGetContext
   }
   /**
    * CGImage -> CVPixelBuffer (⭐ works ⭐)
    * - Note: Ref https://github.com/brianadvent/UIImage-to-CVPixelBuffer/blob/master/ImageProcessor.swift
    * - Important: ⚠️️ This methd exists for testing purpouses, the real code derives the buffer directly
    * - Fixme: ⚠️️ Make debug tool for cgImage: cgImage.bitsPerPixel, cgImage.bitsPerComponent, cgImage.colorSpace, cgImage.byteOrderInfo, cgImage.bitmapInfo, image.size, image.scale, image.cgImage?.bytesPerRow
    * - Parameters:
    *   - cgImage: The cgImage to be converted to CVImageBuffer
    *   - opaque: opaque, aka no alpha
    * - Fixme: ⚠️️ can probably use different combo of buffer rgba, bgra alpha info 32litte etc. figure out what is fastest n the future etc
    * - Fixme: ⚠️️ we dont need opaque param, thats only for png, cam-output, jpg doesnt have alpha.
    * - Fixme: ⚠️️ rename to buffer
    */
   public static func imageBuffer(cgImage: CGImage, opaque: Bool = true) throws -> CVImageBuffer {
      let frameSize = CGSize(width: cgImage.width, height: cgImage.height)
      // - Fixme: ⚠️️ make buffer !
      var buffer: CVPixelBuffer?
      let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(frameSize.width), Int(frameSize.height), kCVPixelFormatType_32BGRA, nil, &buffer)
      if status != kCVReturnSuccess { throw ImgBufferError.statusError }
      CVPixelBufferLockBaseAddress(buffer!, CVPixelBufferLockFlags(rawValue: 0))
      let data = CVPixelBufferGetBaseAddress(buffer!)
      let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
//      let bitmapInfo = opaque ? CGImageAlphaInfo.none.rawValue : CGImageAlphaInfo.premultipliedLast.rawValue
      //CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue),
      let bitmapInfo = CGBitmapInfo(rawValue: CGBitmapInfo.byteOrder32Little.rawValue | CGImageAlphaInfo.premultipliedFirst.rawValue)
      guard let context = CGContext(data: data, width: Int(frameSize.width), height: Int(frameSize.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(buffer!), space: rgbColorSpace, bitmapInfo: bitmapInfo.rawValue) else { throw ImgBufferError.unableToGetContext }
      context.draw(cgImage, in: CGRect(x: 0, y: 0, width: cgImage.width, height: cgImage.height))
      // - Fixme: ⚠️️ Should we unlock buffer here, since we return it etc ?, other repos lock here and still forward buffer
//      let pixelFormatName: String = BufferUtil.pixelFormatName(pixelBuffer: buffer!) // kCVPixelFormatType_2Indexed
//      Swift.print("pixelFormatName:  \(pixelFormatName)")
      CVPixelBufferUnlockBaseAddress(buffer!, CVPixelBufferLockFlags(rawValue: 0))
      return buffer! // - Fixme ⚠️️ add additional throw here
   }
}
