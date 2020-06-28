import Foundation
import CoreImage

class GrayscaleRepParser {
   /**
    * New (⚠️️ experimental, untested, prob needs more research ⚠️️)
    * - Fixme: ⚠️️ rename param
    */
   static func ciImage(grayscaleImage: GrayscaleRep) /*throws*/ -> CIImage {
      let data: Data = .init(buffer: grayscaleImage.pixels)
      // - Fixme: ⚠️️ look for CIFormat for grayscale on google
      // I think the .L8 is monotone?
      let format: CIFormat = .L8//.L8 //.BGRA8 // .RGBA8// .ARGB8//.ABGR8// // A pixel format constant. See Pixel Formats.
      let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceGray()// : CGColorSpaceCreateDeviceRGB()//CGColorSpaceCreateDeviceRGB() // The color space that the image is defined in. It must be a Quartz 2D color space (CGColorSpace). Pass nil for images that don’t contain color data (such as elevation maps, normal vector maps, and sampled function tables).
      let bytesPerRow: Int = grayscaleImage.size.width * 1
      let ciImg: CIImage = .init(bitmapData: data, bytesPerRow: bytesPerRow, size: CGSize(width: CGFloat(grayscaleImage.size.width), height: CGFloat(grayscaleImage.size.height)), format: format, colorSpace: colorSpace)
      return ciImg
   }
}
