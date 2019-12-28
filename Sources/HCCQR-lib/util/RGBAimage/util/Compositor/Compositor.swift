import Foundation
import CoreImage
/**
 * Compositor (Takes 2 Channels and converts to a new b&w QRImage)
 */
final class Compositor {
   /**
    * Returns a qr image based on two rgb channels (We use CIImage, because that is what apple prefers to read qr from)
    * - Note: layer 1: r, b -> qrImg1
    * - Note: layer 2: b, g -> qrImg2
    * - Note: Used in the process to convert HCCQR to Data
    * - Fixme: ⚠️️ possibly simplify method with defering deinit of composite
    */
   static func composite(first: RGBAImage, second: RGBAImage) throws -> CIImage {
      let rgbaImg: RGBAImage = try composite(rgbaImages: [first, second])
      // - Fixme: ⚠️️ here we could use black&white colormap, as it's only for reading bw qr code
      guard let img: CIImage = try? RGBAImageUtil.ciImg2(rgbaImage: rgbaImg) else { rgbaImg.deinitiate(); throw NSError(domain: "Unable to create img", code: 0) }
      rgbaImg.deinitiate() // We deinit the RGBImg after we have consumed it to avoid mem leak
      return img
   }
   /**
    * Combines many images into one
    * - Abstract: we overlay two b&w to produce one b&w image
    * - Note: we invert the image in this method, because doing it in post takes a long time
    * - Note: Used in the process to convert HCCQR to Data
    * - Fixme: ⚠️️ Can the compositing be done simpler, more efficient?
    * - Parameter rgbaImages: an array of RGBAImages to be composited together into 1 RGBAImage
    * - Note: Should really be private, but some tests use it
    */
   /*private */static func composite(rgbaImages: [RGBAImage]) throws -> RGBAImage {
      guard let firstRGBAImg: RGBAImage = rgbaImages.first else { throw NSError(domain: "unable to composite - composite() - no first RGBAImage", code: 0) }
      let size: RGBAImage.Size = (Int(firstRGBAImg.width), Int(firstRGBAImg.height))
      var blackRGBAImg: RGBAImage = .rgbaImage(pixel: PixelData.Colors.blackPixel, size: size) // because black is r:0,b:0,g:0
      blackRGBAImg.process { (index: Int, pixel: PixelData) -> PixelData in // Loop things
         var pixel = pixel // Fixme: ⚠️️ maybe do reduce here?
         rgbaImages.forEach { (rgbaImage: RGBAImage) in // loop over every image in the list
            let rgbaPixelData: PixelData = rgbaImage.pixels[index]
            pixel.applyPixel(first: pixel, second: rgbaPixelData, alpha: 255)
         }
         // - Fixme: ⚠️️ instead of adding, we could substract and then we wouldn't have to invert
         return pixel.inverted() // turn the white pixel into a black
      }
      return blackRGBAImg
   }
}
