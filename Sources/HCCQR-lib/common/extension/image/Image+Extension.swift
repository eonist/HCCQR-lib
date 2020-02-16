import Foundation
import QuartzCore
import CoreImage
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
