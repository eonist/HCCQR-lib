import Foundation
import CoreImage
/**
 * MonoRep with crop
 */
extension MonoRep {
   /**
    * Pure B&W-QR-CIImage 👉 MonoRep (grid of bool values)
    * - Fixme: ⚠️️ rename function to init
    * 1. CIImage comes in
    * 2. Meta data is extracted from the CIImage
    * 3. Pixels are extracted from the CGContext
    * 4. Pixels are added to MonoRep and returned
    * - Abstract: Takes a CIImage and converts it to a GrayScale pixel representation
    * - Note: Seems to be slightly faster than converting CIImage to CGImage etc
    * - Note: Ref https://www.geekspiff.com/unlinkedCrap/ciImageToBitmap.html
    * - Note: Use ciImg.debugDescription to find more info about cgImage
    * - Caution: ⚠️️ Only works if CIImage is pure black and white, which is the case for generated qr images
    * - Parameters:
    *   - ciImg: The CIImage to convert to monotone representative
    *   - crop: Supports cropping
    */
   internal static func monoRep(ciImg: CIImage, crop: BufferRect? = nil) throws -> MonoRep {
      let crop: BufferRect = crop ?? .init(0, 0, Int(ciImg.extent.width), Int(ciImg.extent.height))
      let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceRGB()
//      let size: Size = (width: Int(ciImg.extent.width), height: Int(ciImg.extent.height))
      let capacity: Int = crop.width * crop.height
      let bytesPerRow: Int = crop.width * 4 // We multiply per 4 because of the 4 channels, RGBA
      let imageData: UnsafeMutablePointer<Pixel> = .allocate(capacity: capacity)
      // - Fixme: ⚠️️ Do we have to create the cgContext? can CIContext be created directly from pixeldata?
      guard let cgContext = CGContext(data: imageData, width: crop.width, height: crop.height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: RGBARep.bitmapInfo) else { throw NSError(domain: "rgbaImage - Unable to create rgbaImage", code: 0) }
      let context: CIContext = .init(cgContext: cgContext, options: nil) // .init(options: nil)// = CIContext.init(cgContext: , options: )
      let fromExtent: CGRect = crop.cgRect
      context.draw(ciImg, in: ciImg.extent, from: fromExtent)
      let pixels: UnsafeMutableBufferPointer<Pixel> = .init(start: imageData, count: capacity)
      let monotonePixels: UnsafeMutableBufferPointer<Bool> = .allocate(capacity: capacity)
      pixels.enumerated().forEach { monotonePixels[$0.offset] = $0.element.isWhite } // set bools (white is true, black is false)
      //       defer { imageData.deallocate() } // ⚠️️ new
      defer { pixels.deallocate() } // dealloc this, as we have no more use for it
      return .init(pixels: monotonePixels, width: crop.width, height: crop.height)
   }
}
