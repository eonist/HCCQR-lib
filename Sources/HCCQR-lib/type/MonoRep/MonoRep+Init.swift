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
    * - Fixme: ⚠️️ we could try using UnsafeMutableRawPointer for imageData, could be faster ?, need more info
    * - Parameters:
    *   - ciImg: The CIImage to convert to monotone representative
    *   - crop: Supports cropping
    */
   internal static func monoRep(ciImg: CIImage, crop: BufferRect? = nil) throws -> MonoRep {
      let crop: BufferRect = crop ?? .init(0, 0, Int(ciImg.extent.width), Int(ciImg.extent.height))
      let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceRGB()
      // let size: Size = (width: Int(ciImg.extent.width), height: Int(ciImg.extent.height))
      let capacity: Int = crop.width * crop.height
      let bytesPerRow: Int = crop.width * 4 // We multiply per 4 because of the 4 channels, RGBA
      let imageData: UnsafeMutablePointer<Pixel> = .allocate(capacity: capacity)
      // - Fixme: ⚠️️ Do we have to create the cgContext? can CIContext be created directly from pixeldata?
      guard let cgContext = CGContext(data: imageData, width: crop.width, height: crop.height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: RGBARep.bitmapInfo) else { throw NSError(domain: "rgbaImage - Unable to create rgbaImage", code: 0) }
      // autoreleasepool avoids contextleak, might be a bit slower than other solution
      let context: CIContext = autoreleasepool {
         .init(cgContext: cgContext, options: nil)
      }
      let fromExtent: CGRect = crop.cgRect
      context.draw(ciImg, in: ciImg.extent, from: fromExtent)
      let monoPixels: UnsafeMutableBufferPointer<Bool> = .allocate(capacity: capacity)
      (0..<capacity).forEach { i in
         monoPixels[i] = imageData.advanced(by: i).pointee.isWhite
      }
      imageData.deallocate() // we have no more use for imageData
      return .init(pixels: .init(monoPixels), width: crop.width, height: crop.height)
   }
}
