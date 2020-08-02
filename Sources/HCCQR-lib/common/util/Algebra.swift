import QuartzCore

final class Algebra {
   /**
    * Find exponent when you have base and result
    * - Parameters:
    *   - base: 2^3 = 8 (2 is the base)
    *   - value: 2^3 = 8 (8 is the value or the result if you like)
    * ## Examples:
    * print(exponent(base: 2, value: 4)) // 2
    * print(exponent(base: 2, value: 8)) // 3
    * print(exponent(base: 2, value: 16)) // 4
    * print(exponent(base: 2, value: 128)) // 7
    * print(exponent(base: 2, value: 256)) // 8
    */
   static func exponent(base: CGFloat, value: CGFloat) -> CGFloat {
      log(value) / log(base)
   }
}
/**
 * Convenient
 */
extension Algebra {
   /**
    * Convenient for Int
    */
   static func exponent(base: Int, value: Int) -> Int {
      Int(exponent(base: CGFloat(base), value: CGFloat(value)))
   }
}
