import Foundation
import QR_lib
import CoreImage

extension Writer {
   /**
    * onCreateCIImgComplete (New)
    * - Note: Used in the process of converting Data to HCCQR
    * 1. CIImage's comes in
    * 2. When the result array is full of CIImages the colorizing starts
    * 3. Colorize grayscale CIImages
    * 4. return RGBA image
    * - Important: ⚠️️ We could get raw grayscale or even bool info, but for now we use apples qr-creation method, and that uses CIImage as output
    * - Parameters:
    *   - i: the index of the CIImage to be placed in the result-array
    *   - ciImg: The image to be placed in the result-array
    *   - ciImgs: The completion result array (initially populated with nils)
    *   - scale: Screen and module scale
    *   - useDarkMode: Toggle between dark and light mode (dark / white background)
    *   - onComplete: Return the complete HCCQR image from grayscale QR represenations
    */
   internal static func onQRImageComplete(i: Int, ciImg: CIImage?, ciImgs:inout [CIImage?], config: HCCQRSetup, onComplete: OnRGBAImageComplete) {
      guard let ciImg: CIImage = ciImg else { onComplete(.failure(.unableToCreateCIImage)); return }
      ciImgs[i] = ciImg // It matters which order the QRImage's came in when you stitch them back together
      if !ciImgs.contains(where: { $0 == nil }) { // Makes sure all images finished (aka no nil values)
         let ciImages: [CIImage] = ciImgs.compactMap { $0 } // Removes nils
//         let colorMap: Colorizer.ColorMap = Colorizer.colorMap(useDarkMode: useDarkMode)
         guard let rgbaImage: RGBARep = try? Colorizer.colorize(ciImages: ciImages, colorMap: config.map, scale: config.scale) else { onComplete(.failure(.unableToCreateColorizedImage)); return }
         onComplete(.success(rgbaImage))
      }
   }
}
