import Foundation
import CoreImage

typealias GrayRepParser = GrayRep

extension GrayRepParser {
   /**
    * Convert GrayRep to CIImage
    * - Note: Experimental, untested, prob needs more research, it works tho ⚠️️
    * - Note: Fast grayscale: https://developer.apple.com/documentation/accelerate/converting_color_images_to_grayscale  and vImage_CGImageFormat might also be interesting
    * - Note: I think the .L8 is monotone? prob GrayScale
    * - Parameter grayRep: the rep to convert to CIImage
    */
   static func ciImage(grayRep: GrayRep) -> CIImage {
      let fromFormat: CIFormat = .L8 //.L8 //.BGRA8 // .RGBA8// .ARGB8//.ABGR8// // A pixel format constant. See Pixel Formats.
      let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceGray()// : CGColorSpaceCreateDeviceRGB()//CGColorSpaceCreateDeviceRGB() // The color space that the image is defined in. It must be a Quartz 2D color space (CGColorSpace). Pass nil for images that don’t contain color data (such as elevation maps, normal vector maps, and sampled function tables).
      let bytesPerRow: Int = grayRep.size.width
      let data: Data = .init(buffer: grayRep.pixels)
      return .init(bitmapData: data, bytesPerRow: bytesPerRow, size: grayRep.size.cgSize, format: fromFormat, colorSpace: colorSpace)
   }
}
