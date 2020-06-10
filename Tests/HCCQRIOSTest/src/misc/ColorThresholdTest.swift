import Foundation

class ColorThresholdTest {
   /**
    * - Fixme: ⚠️️ Write doc
    */
   static func test() {
      let a = UInt8Parser.range(num: 100, halfThreshold: 25, min: 0, max: 255) // 75, 125
      Swift.print("a:  \(a)")
      let b = UInt8Parser.range(num: 20, halfThreshold: 25, min: 0, max: 255) // 0, 50
      Swift.print("b:  \(b)")
      let c = UInt8Parser.range(num: 230, halfThreshold: 25, min: 0, max: 255) // 205, 255
      Swift.print("c:  \(c)")
      let d = UInt8Parser.range(num: 0, halfThreshold: 25, min: 0, max: 255) // 0, 50
      Swift.print("d:  \(d)")
      let e = UInt8Parser.range(num: 255, halfThreshold: 25, min: 0, max: 255) // 205, 255
      Swift.print("e:  \(e)")
   }
}
