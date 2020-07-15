import Foundation
import CoreImage
/**
 * - Fixme: ⚠️️ rename to ..rep
 */
final class RGBARepModifier {
   /**
    * Scales img without becoming blurry (Sharp pixel multiplier)
    * - Note: This method is used when creating HCCQR images from data
    * - Note: Assert if scaling is needed before callign this method
    * - Fixme: ⚠️️ Add the concurrent optimization for nested for loops, striding?
    * - Fixme: ⚠️️ Can we "bake" this direcltly into the composition method, to avoid extra loops?
    * - Parameters:
    *   - pixels: the pixels array
    *   - size: size of the rgba-rep
    *   - scale: The amount to scale the pixel by (module, screen)
    */
   static func scale(pixels: UnsafeMutableBufferPointer<Pixel>, size: Size, scale: Scale) -> RGBARep {
      let scale: Int = scale.module * scale.screen // multiply screen and module multiplier
      let scaledSize: Size = (size.width * scale, size.height * scale)
      let capacity: Int = scaledSize.width * scaledSize.height
      let resultPixels: UnsafeMutableBufferPointer<Pixel> = .allocate(capacity: capacity)
      // - Fixme: ⚠️️ do concurrent + stride?
      (0..<scaledSize.height).forEach { (y: Int) in
         let scaledY = y / scale * size.height
         let yWidth = y * scaledSize.width
         // - Fixme: ⚠️️ optimal amount of work on bellow is suboptimal
         (0..<scaledSize.width).forEach { (x: Int) in
//         DispatchQueue.concurrentPerform(iterations: scaledSize.width) { x in // Optimization initiative, might be faster
            let pixIndex: Int = scaledY + x / scale
            let resIndex: Int = yWidth + x
            resultPixels[resIndex] = pixels[pixIndex]
         }
      }
      return .init(pixels: resultPixels, width: scaledSize.width, height: scaledSize.height)
   }
}
/**
 * Experimental
 */
extension RGBARepModifier {
   /**
    * Combines many rgbaRep's into one
    * - Parameters:
    *   - rgbaReps: reps to be merged into one (has to be in 1 column)
    *   - size: final output size (has to be the combined size of all rgbaReps)
    */
   static func combine(rgbaReps: [RGBARep], size: Size) -> RGBARep {
      Swift.print("combine.size:  \(size)")
      let capacity: Int = size.width * size.height
      let resultPixels: UnsafeMutableBufferPointer<Pixel> = .allocate(capacity: capacity)
      Swift.print("rgbaReps.count:  \(rgbaReps.count)")
      //      rgbaReps.map { $0.pixels }.enumerated().forEach { resultPixels[$0.offset] = $0.element }
      var rowYOffset: Int = 0
      //      var i: Int = 0
      rgbaReps.forEach { (rgbaRep: RGBARep) in
         Swift.print("rgbaRep.height:  \(rgbaRep.height)")
         Swift.print("rgbaRep.width:  \(rgbaRep.width)")
         Swift.print("rowYOffset:  \(rowYOffset)")
         // 🏀
         // figure out the chopping height
         // think of a way to increment the array, dra on paper with simple data
         // the way this works is that for every yRow we write until width
         (0..<rgbaRep.height).forEach { (y: Int) in // 276
            //            let offsetY = y * i
            // - Fixme: ⚠️️ do some of the y calc here
            (0..<rgbaRep.width).forEach { (x: Int) in // 276
               let idx: Int = y * rgbaRep.width + x // every x pixel
               //               Swift.print("y \(y) x: \(x) rgbaRep.width \(rgbaRep.width) rgbaRep.height: \(rgbaRep.height) idx:  \(idx) ")
               let resultIdx: Int = rowYOffset + idx
               Swift.print("resultIdx:  \(resultIdx)")
               resultPixels[resultIdx] = rgbaRep.pixels[idx]
               //               i += 1
            }
         }
         //            Swift.print("rowYOffset:  \(rowYOffset)")
         //         Swift.print("rgbaRep.height:  \(rgbaRep.height)")
         rowYOffset += rgbaRep.width * rgbaRep.height // increment the height
      }
      //      Swift.print("i:  \(i)")
      Swift.print("capacity:  \(capacity)")
      let result: RGBARep = .init(pixels: resultPixels, width: size.width, height: size.height)
      return result
   }
}
