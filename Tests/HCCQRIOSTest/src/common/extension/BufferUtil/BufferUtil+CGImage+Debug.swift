import AVFoundation
import QuartzCore
import CoreImage
@testable import HCCQR_lib

extension BufferUtil {
   /**
    * CGImage -> CVPixelBuffer (⭐ works ⭐)
    * - Note: Ref https://github.com/brianadvent/UIImage-to-CVPixelBuffer/blob/master/ImageProcessor.swift
    * - Important: ⚠️️ This methd exists for testing purpouses, the real code derives the buffer directly
    * - Fixme: ⚠️️ Make debug tool for cgImage: cgImage.bitsPerPixel, cgImage.bitsPerComponent, cgImage.colorSpace, cgImage.byteOrderInfo, cgImage.bitmapInfo, image.size, image.scale, image.cgImage?.bytesPerRow
    * - Parameter cgImage: The cgImage to be converted to CVImageBuffer
    */
   public static func imageBuffer(cgImage: CGImage) throws -> CVImageBuffer {
      let frameSize = CGSize(width: cgImage.width, height: cgImage.height)
      var buffer: CVPixelBuffer?
      let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(frameSize.width), Int(frameSize.height), kCVPixelFormatType_32BGRA, nil, &buffer)
      if status != kCVReturnSuccess { throw NSError(domain: "status err", code: 0) }
      CVPixelBufferLockBaseAddress(buffer!, CVPixelBufferLockFlags(rawValue: 0))
      let data = CVPixelBufferGetBaseAddress(buffer!)
      let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
      let bitmapInfo = CGBitmapInfo(rawValue: CGBitmapInfo.byteOrder32Little.rawValue | CGImageAlphaInfo.premultipliedFirst.rawValue)
      guard let context = CGContext(data: data, width: Int(frameSize.width), height: Int(frameSize.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(buffer!), space: rgbColorSpace, bitmapInfo: bitmapInfo.rawValue) else { Swift.print("Unable to get context"); throw NSError(domain: "Unable to get context", code: 0) }
      context.draw(cgImage, in: CGRect(x: 0, y: 0, width: cgImage.width, height: cgImage.height))
      // - Fixme: ⚠️️ Should we unlock buffer here, since we return it etc ?, other repos lock here and still forward buffer
      let pixelFormatName: String = BufferUtil.pixelFormatName(pixelBuffer: buffer!) // kCVPixelFormatType_2Indexed
      Swift.print("pixelFormatName:  \(pixelFormatName)")
      CVPixelBufferUnlockBaseAddress(buffer!, CVPixelBufferLockFlags(rawValue: 0))
      return buffer! // - Fixme ⚠️️ add additional throw here
   }
}
