import Foundation
import CoreImage

protocol ImageRepKind {
   var pixels: UnsafeBufferPointer<PixelData> { get }
   var width: Int { get }
   var height: Int { get }
   // image
   func cgImage() throws -> CGImage
   func ciImage(useGrayscale: Bool) throws -> CIImage
   func image(scale: CGFloat) throws -> Image
   // init
   static func imageRep(image: Image) throws -> ImageRepKind
//   func imageRep(cgImage: CGImage) throws -> ImageRepKind
}
