import Foundation
import QuartzCore
import CoreImage
/**
 * Asserter
 */
extension Image {
   /**
    * Compare images
    * - Parameter image: the image to assert against
    */
   public func isEqualToImage(image: Image) -> Bool {
      return self.pngData() == image.pngData()
   }
}
/**
 * Parsers
 */
extension Image {
   /**
    * - Note: Somehow this works with retina images where scale is 2x as well
    * - Note: alternative: https://gist.github.com/giulio92/69e4f74217422154bb25d2a35d6710f8
    * - Fixme: ⚠️️ cgImage or cgImage doesn't always work, try to make this more consistent
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
    * Returns color of every pixel in an image
    * - Fixme: Should return optional
    */
   var pixelColors: [Color] {
      //⚠️️ The bellow fix could hurt performance
      guard let cgImage = /*self.cgImage ?? */self.cgImage() else { Swift.print("getPixelColor() - unable to get cgImage"); return [] }
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
/**
 * Converters
 */
extension Image {
   /**
    * - Note: A CIContext can be CPU or GPU based. A CIContext is relatively expensive to initialize so you reuse it rather than create it over and over
    */
   static var ciContext: CIContext = .init(options: nil)
   /**
    * someUIImage.cgImage doesn't work so we use this
    */
   #if os(iOS)
   func cgImage() -> CGImage? {
      return self.cgImage ?? { // quick fix
         guard let ciImage: CIImage = self.ciImage else { Swift.print("cgImage() - unable to get ciImage"); return nil }
         return autoreleasepool { // ⚠️️ testing to get rid of mem leak ⚠️️ new
            return Image.ciContext.createCGImage(ciImage, from: ciImage.extent) // let context: CIContext = .init(options: nil)
         }
         }()
   }
   #elseif os(macOS)
   /**
    * Creates cgimage from nsimage
    * - Important: ⚠️️ we use autoreleasepool{} or else there will be memory leakage
    */
   func cgImage() -> CGImage? {
      return autoreleasepool {
         self.cgImage(forProposedRect: nil, context: nil, hints: nil)
      }
   }
   #endif
}
/**
 * Temp solution
 */
extension Image {
   #if os(macOS)
   var scale: CGFloat { return 1 }
   #endif
}
#if os(iOS)
extension CIContext {
   /**
    * ⚠️️ Untested ⚠️️ Could stop the mem leaking that happens when converting to cgimg
    * - Fixme: ⚠️️ get rid of forced unwraps
    * - Note: ref https://stackoverflow.com/a/32686370/5389500
    */
   func cgImg(ciImage: CIImage, from fromRect: CGRect) -> CGImage {
      let width = Int(fromRect.width)
      let height = Int(fromRect.height)
      let rawData = UnsafeMutablePointer<UInt8>.allocate(capacity: width * height * 4)
      render(ciImage, toBitmap: rawData, rowBytes: width * 4, bounds: fromRect, format: .RGBA8, colorSpace: CGColorSpaceCreateDeviceRGB())
      let dataProvider = CGDataProvider(dataInfo: nil, data: rawData, size: height * width * 4) { _, data, _ in data.deallocate() }
      return CGImage(width: width, height: height, bitsPerComponent: 8, bitsPerPixel: 32, bytesPerRow: width * 4, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue), provider: dataProvider!, decode: nil, shouldInterpolate: false, intent: .defaultIntent)!
   }
}
#endif
