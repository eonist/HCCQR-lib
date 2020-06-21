import Foundation
import QuartzCore
import CoreImage
//@testable import HCCQR_lib
/**
 * Asserter
 */
extension Image {
   /**
    * Compare images
    * - Parameter image: the image to assert against
    */
   public func isEqualToImage(image: Image) -> Bool {
      self.pngData() == image.pngData()
   }
}
/**
 * Parsers
 */
extension Image {
   /**
    * Returns color of every pixel in an image
    * - Fixme: ⚠️️ Should return optional
    */
   var pixelColors: [Color] {
      // ⚠️️ The bellow fix could hurt performance
      guard let cgImage = /*self.cgImage ?? */ self.cgImage() else { Swift.print("getPixelColor() - unable to get cgImage"); return [] }
      guard let dataProvider = cgImage.dataProvider else { Swift.print("getPixelColor() - unable to get dataProvider"); return [] }
      guard let pixelData: CFData = dataProvider.data else { Swift.print("getPixelColor() - unable to get cfData"); return [] }
      let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
      let (width, height) = (Int(size.width), Int(size.height))
      return (0..<height).flatMap { y in
         (0..<width).compactMap { x in
            getPixelColor(pos: .init(x: x, y: y), data: data)
         }
      }
   }
}
/**
 * Internal helper method
 */
extension Image {
   /**
    * - Note: Somehow this works with retina images where scale is 2x as well
    * - Note: alternative: https://gist.github.com/giulio92/69e4f74217422154bb25d2a35d6710f8
    * - Fixme: ⚠️️ cgImage or CGImage doesn't always work, try to make this more consistent
    * - Fixme: ⚠️️ Make this throw
    * - Parameter pos: The x/y position in the image to grab color from
    */
   private func getPixelColor(pos: CGPoint) -> Color? { // Fixme: ⚠️️ make this for cgImage, converting it over and over is not good
      // ⚠️️ The bellow fix could hurt performance
      guard let cgImage = /*self.cgImage ?? */self.cgImage() else { Swift.print("getPixelColor() - unable to get cgImage"); return nil }
      guard let dataProvider = cgImage.dataProvider else { Swift.print("getPixelColor() - unable to get dataProvider"); return nil }
      guard let pixelData: CFData = dataProvider.data else { Swift.print("getPixelColor() - unable to get cfData"); return nil }
      let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
      return getPixelColor(pos: pos, data: data)
   }
   /**
    * Internal helper
    * - Parameters:
    *   - pos: The x/y position in the image to grab color from
    *   - data: all individual pixels from an image
    */
   private func getPixelColor(pos: CGPoint, data: UnsafePointer<UInt8>) -> Color? {
      let pixelInfo: Int = ((Int(self.size.width * self.scale) * Int(pos.y)) + Int(pos.x)) * 4
      let r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
      let g = CGFloat(data[pixelInfo + 1]) / CGFloat(255.0)
      let b = CGFloat(data[pixelInfo + 2]) / CGFloat(255.0)
      let a = CGFloat(data[pixelInfo + 3]) / CGFloat(255.0)
      return Color(red: r, green: g, blue: b, alpha: a)
   }
}
