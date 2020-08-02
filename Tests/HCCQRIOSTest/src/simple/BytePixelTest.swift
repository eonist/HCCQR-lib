import Foundation
@testable import HCCQR_lib

final class BytePixelTest {
   /**
    * Test bytepixel
    */
   static func test() -> Bool {
      let bytePix: BytePixel = .init(r: 255, g: 0, b: 0)
//      Swift.print("bytePix:  \(bytePix.value)")
      let isValidHex: Bool = bytePix.value == 255//0xFF0000
//      Swift.print("isValidHex:  \(isValidHex)")
      let isRed = bytePix.r == UInt8(255)
//      Swift.print("bytePix.r:  \(bytePix.r)")
//      Swift.print("isRed:  \(isRed)")
//      Swift.print("bytePix.g:  \(bytePix.g)")
      let isGreen = bytePix.g == UInt8(0)
//      Swift.print("isGreen:  \(isGreen)")
      let isBlue = bytePix.b == UInt8(0)
//      Swift.print("bytePix.b:  \(bytePix.b)")
//      Swift.print("isBlue:  \(isBlue)")
      let isValid = isValidHex && isRed && isGreen && isBlue
//      print("BytePixelTest \(isValid ? "✅" : "🚫")")
      return isValid
   }
}
