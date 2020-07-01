import Foundation
/**
 * PixelData (holds a color for a pixel)
 * - Fixme: ⚠️️⚠️️⚠️️ get rid of alpha, because there is no alpha, just be careful that you don't ruin the conversion methods that rely on struct being what it is etc
 */
public struct Pixel {
   var r: UInt8
   var g: UInt8
   var b: UInt8
   var a: UInt8
}
