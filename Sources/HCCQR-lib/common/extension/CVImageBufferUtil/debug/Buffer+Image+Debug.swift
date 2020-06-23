import AVFoundation
import QuartzCore
import CoreImage

extension CVImageBufferUtil {
   /**
    * UIImage -> CVPixelBuffer
    * - Fixme: ⚠️️ add step doc 
    * - Note: Ref https://www.hackingwithswift.com/whats-new-in-ios-11 and https://stackoverflow.com/a/44475334/5389500
    * - Note: Alternative https://gist.github.com/omarojo/b47ad0f0965ba8bf2e825ef571ef804c
    * - Fixme: ⚠️️ Use Metal: https://developer.apple.com/documentation/coreimage/cicontext/1437609-init
    * - Note: CGImage to Buffer https://github.com/brianadvent/UIImage-to-CVPixelBuffer/blob/master/ImageProcessor.swift
    * - Note: ref https://stackoverflow.com/questions/3838696/convert-uiimage-to-cvpixelbufferref
    * - Note: ref https://stackoverflow.com/questions/44462087/how-to-convert-a-uiimage-to-a-cvpixelbuffer
    * - Parameter image: Convert this image to CVImageBuffer
    */
   public static func imageBuffer(image: Image) throws -> CVImageBuffer {
      guard let cgImage = image.cgImage() else { throw NSError(domain: "unable to get cgimage", code: 0) }
      return try imageBuffer(cgImage: cgImage)
   }
}
