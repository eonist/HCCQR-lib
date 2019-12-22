import Foundation
import RGBKit
import QuartzCore

extension RGBImage {
   /**
    * RGBImage -> RGBAImage
    */
   var rgbaImage: RGBAImage {
      let pixels: [PixelData] = self.pixels.map { PixelData(r: $0.r, g: $0.g, b: $0.b, a: 255) }
      return .rgbaImage(pixels: pixels, size: (width: self.width, height: self.height))
//      return RGBAImage.rgbaImage(pixels: pixels, size: .init(width: self.width, height: self.height))
   }
}
