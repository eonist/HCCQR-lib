import Foundation
import CoreImage
/**
 * Compositor
 */
internal class Compositor {
   /**
    * Returns a qr image based on two rgb channels
    * - Note: layer 1: r, b -> qrImg1
    * - Note: layer 2: b, g -> qrImg2
    * - Fixme: ⚠️️ Make it throw
    * - posibly simplify method with defering deinit of composite
    */
   internal static func composite(first: RGBAImage, second: RGBAImage) throws -> CIImage {
      let composite: RGBAImage = try Compositor.composite(rgbaImageList: [first, second], invert: true)
      guard let img: CIImage = try? RGBAImage.ciImage(rgbaImage: composite) else { composite.deinitiate(); throw NSError.init(domain: "Unable to create img", code: 0) }
      composite.deinitiate() // To avoid mem leak
      return img
   }
   /**
    * Combines many images into one
    * - Note: we invert the image in this method, because doing it in post takes a long time
    * - Fixme: ⚠️️ Can the compositing be done simpler, more efficient?
    * - Parameter rgbaImageList: an array of RGBAImages to be composited together into 1 RGBAImage
    */
   internal static func composite(rgbaImageList: [RGBAImage], invert: Bool) throws -> RGBAImage {
      guard let firstRGBAImg: RGBAImage = rgbaImageList.first else { throw NSError.init(domain: "unable to composite - composite() - no first", code: 0) }
      let size: RGBAImage.Size = (Int(firstRGBAImg.width), Int(firstRGBAImg.height))
      var blackRGBAImg: RGBAImage = .rgbaImage(pixel: .blackPixel, size: size)
      blackRGBAImg.process { (index: Int, pixel: PixelData) -> PixelData in // Loop things
         var pixel = pixel // Fixme: ⚠️️ maybe do reduce here?
         rgbaImageList.forEach { (rgbaImage: RGBAImage) in // loop over every image in the list
            let rgbaPixelData: PixelData = rgbaImage.pixels[index]
            pixel.setRGBA(first: pixel, second: rgbaPixelData, alpha: 255)
         }
         return invert ? pixel.inverted() : pixel
      }
      return blackRGBAImg
   }
}
