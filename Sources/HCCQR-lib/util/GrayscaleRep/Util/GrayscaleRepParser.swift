import Foundation
import CoreImage

class GrayscaleRepParser {
   /**
    * New (⚠️️ experimental, untested, prob needs more research ⚠️️)
    * - Fixme: ⚠️️ rename param
    * - Note: fast grayscale: https://developer.apple.com/documentation/accelerate/converting_color_images_to_grayscale
    */
   static func ciImage(grayscaleRep: GrayscaleRep) /*throws*/ -> CIImage {
      let data: Data = .init(buffer: grayscaleRep.pixels)
      // - Fixme: ⚠️️ look for CIFormat for grayscale on google
      // I think the .L8 is monotone?
      let format: CIFormat = .L8//.L8 //.BGRA8 // .RGBA8// .ARGB8//.ABGR8// // A pixel format constant. See Pixel Formats.
      let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceGray()// : CGColorSpaceCreateDeviceRGB()//CGColorSpaceCreateDeviceRGB() // The color space that the image is defined in. It must be a Quartz 2D color space (CGColorSpace). Pass nil for images that don’t contain color data (such as elevation maps, normal vector maps, and sampled function tables).
      let bytesPerRow: Int = grayscaleRep.size.width * 1
      let ciImg: CIImage = .init(bitmapData: data, bytesPerRow: bytesPerRow, size: CGSize(width: CGFloat(grayscaleRep.size.width), height: CGFloat(grayscaleRep.size.height)), format: format, colorSpace: colorSpace)
      return ciImg
   }
}
//   private static var monoFormat {
//      guard let monoFormat = vImage_CGImageFormat(
//         bitsPerComponent: 8,
//         bitsPerPixel: 8,
//         colorSpace: CGColorSpaceCreateDeviceGray(),
//         bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue),
//         renderingIntent: .defaultIntent) else {
//            return
//      }
//   }
