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
      self.cgImage ?? { // quick fix
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
      autoreleasepool {
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
   var scale: CGFloat { 1 } // - Fixme: ⚠️️ this should probably be dynamic or based on some internal value no?
   #endif
}
