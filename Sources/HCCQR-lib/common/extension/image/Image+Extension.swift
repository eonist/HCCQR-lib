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
   internal static var ciContext: CIContext = .init(options: nil)
   /**
    * someUIImage.cgImage doesn't work so we use this
    * - Note: Image can be backed by CGImage or CIImage
    */
   #if os(iOS)
   public func cgImage() -> CGImage? {
      self.cgImage ?? { // isnt backed by cgImage
         guard let ciImage: CIImage = self.ciImage else { Swift.print("cgImage() - unable to get ciImage"); return nil }
//         return autoreleasepool { // ⚠️️ testing to get rid of mem leak ⚠️️ new
            return Image.ciContext.createCGImage(ciImage, from: ciImage.extent) // let context: CIContext = .init(options: nil)
//         }
      }()
   }
   #elseif os(macOS)
   /**
    * Creates cgimage from nsimage
    * - Important: ⚠️️ we use autoreleasepool{} or else there will be memory leakage
    */
   public func cgImage() -> CGImage? {
//      autoreleasepool {
         self.cgImage(forProposedRect: nil, context: nil, hints: nil)
//      }
   }
   #endif
   /**
    * works better than ciImage() when dealing with qr based ciimages
    */
   public func ciImg() -> CIImage? {
      #if os(macOS)
      return ciImage()
      #else
      return ciImage
      #endif
   }
}
/**
 * Temp solution
 */
extension Image {
   #if os(macOS)
   var scale: CGFloat { 1 } // - Fixme: ⚠️️ this should probably be dynamic or based on some internal value no?
   #endif
}
extension CIContext {
   // finish the bellow, coul fix CIcontext leak
//   func createCGImage_(image:CIImage, fromRect:CGRect) -> CGImage {
//      let width = Int(fromRect.width)
//      let height = Int(fromRect.height)
//
//      let rawData =  UnsafeMutablePointer<UInt8>.allocate(capacity: width * height * 4)
//      render(image, toBitmap: rawData, rowBytes: width * 4, bounds: fromRect, format: CIFormat.RGBA8, colorSpace: CGColorSpaceCreateDeviceRGB())
////      let dataProvider = CGDataProviderCreateWithData(nil, rawData, height * width * 4) { info, data, size in
////         UnsafeMutablePointer<UInt8>.//.dealloc(size)
////      }
//      let dataProvider = CGDataProviderCreateWithData
//         
////         CGDataProvider.init(directInfo: rawData, size: height * width * 4) { info, data, size  in
////
////      }
//      return CGImageCreate(width, height, 8, 32, width * 4, CGColorSpaceCreateDeviceRGB(), CGBitmapInfo(rawValue: CGImageAlphaInfo.PremultipliedLast.rawValue), dataProvider, nil, false, .RenderingIntentDefault)!
//   }
}
